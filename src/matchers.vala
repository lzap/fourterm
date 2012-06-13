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
    var command = matchers[index].command(match);
    try {
      GLib.Process.spawn_command_line_async(command);
    } catch(GLib.SpawnError error) {
#if DEBUG
      this.display_get_key_error(error.message);
#endif
    }
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
  public abstract string command(string match);
}

public class UrlMatcher : GLib.Object, IMatcher
{
  public string name() {
    return "url";
  }

  public string regex() {
    return "(((file|http|ftp|https)://)|(www|ftp)[-A-Za-z0-9]*\\.)[-A-Za-z0-9\\.]+(:[0-9]*)?/[-A-Za-z0-9_\\$\\.\\+\\!\\*\\(\\),;:@&=\\?/~\\#\\%]*[^]'\\.}>\\) ,\\\"]";
  }

  public string command(string match) {
    return "google-chrome " + match;
  }
}

public class RubyMatcher : GLib.Object, IMatcher
{
  public string name() {
    return "ruby";
  }

  public string regex() {
    return """File\s\"(.*)\",\sline\s(\d+)""";
  }

  public string command(string match) {
    return "gvim " + match;
  }
}

// TODO - test this
public class PythonMatcher : GLib.Object, IMatcher
{
  public string name() {
    return "python";
  }

  public string regex() {
    return """(^|\s)(\S*):(\d+)""";
  }

  public string command(string match) {
    return "gvim " + match;
  }
}

