/****************************
** Copyright © 2012 Lukas Zapletal
**
** ValaTerm is free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program.  If not, see <http://www.gnu.org/licenses/>.
****************************/

public class MatcherManager : GLib.Object
{
  private Terminal terminal;
  private Gee.HashMap<int, IMatcher> matchers = new Gee.HashMap<int, IMatcher>();
  
  public MatcherManager(Terminal terminal) {
    this.terminal = terminal;
    add_matcher(new UrlMatcher());
    add_matcher(new RubyMatcher());
    add_matcher(new PythonMatcher());
  }

  public void apply_action(string match, int index) {
    try {
      var matcher = matchers[index];
      // create regex
      Regex r = new Regex(matcher.regex());
      MatchInfo info;
      if (r.match(match, 0, out info)) {
        // find groups
        var groups = info.fetch_all();
        // check if file exists
        if (file_exists(matcher.matched_filename(groups))) {
          // execute command
          var command = matcher.command(groups);
          if (command != null)
            GLib.Process.spawn_command_line_async(command);
        }
      }
    } catch (GLib.RegexError error) {
#if DEBUG
      this.display_get_key_error(error.message);
#endif
    } catch (GLib.SpawnError error) {
#if DEBUG
      this.display_get_key_error(error.message);
#endif
    }
  }

  // checks if file exists (incl. project dirs)
  public bool file_exists(string filename) {
    var file = File.new_for_path(filename);
    if (file.query_exists())
      return true;
    else
      return false;
  }

  private void add_matcher(IMatcher matcher) {
    try {
      var ix = terminal.match_add_gregex(new GLib.Regex(matcher.regex()), 0);
      matchers[ix] = matcher;
    } catch(GLib.Error error) {
#if DEBUG
      this.display_get_key_error(error.message);
#endif
    }
  }
}

public interface IMatcher : GLib.Object
{
  public abstract string name();
  public abstract string regex();
  public abstract string command(string[] groups);
  public abstract string matched_filename(string[] groups);
  public abstract string matched_line(string[] groups);
}

public class UrlMatcher : GLib.Object, IMatcher
{
  public string name() {
    return "url";
  }

  public string regex() {
    return "(((file|http|ftp|https)://)|(www|ftp)[-A-Za-z0-9]*\\.)[-A-Za-z0-9\\.]+(:[0-9]*)?/[-A-Za-z0-9_\\$\\.\\+\\!\\*\\(\\),;:@&=\\?/~\\#\\%]*[^]'\\.}>\\) ,\\\"]";
  }

  public string matched_filename(string[] groups) {
    return ""; // not used
  }

  public string matched_line(string[] groups) {
    return ""; // not used
  }

  public string command(string[] groups) {
    return "google-chrome " + groups[0];
  }
}

public class PythonMatcher : GLib.Object, IMatcher
{
  public string name() {
    return "python";
  }

  public string regex() {
    return """File\s\"(.*)\",\sline\s(\d+)""";
  }

  public string matched_filename(string[] groups) {
    return groups[1];
  }

  public string matched_line(string[] groups) {
    return groups[2];
  }

  public string command(string[] groups) {
    var filename = matched_filename(groups);
    var line = matched_line(groups);
    return @"gvim $filename +$line";
  }
}

public class RubyMatcher : GLib.Object, IMatcher
{
  public string name() {
    return "ruby";
  }

  public string regex() {
    return """(^|\s)(\S*):(\d+)""";
  }

  public string matched_filename(string[] groups) {
    return groups[1] + groups[2];
  }

  public string matched_line(string[] groups) {
    return groups[3];
  }

  public string command(string[] groups) {
    var filename = matched_filename(groups);
    var line = matched_line(groups);
    return @"gvim $filename +$line";
  }
}

