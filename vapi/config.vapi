[CCode (cheader_filename = "config.h")]
namespace Config
{
	[CCode (cname = "VERSION")]
	public const string VERSION;
	[CCode (cname = "GETTEXT_PACKAGE")]
	public const string GETTEXT_PACKAGE;
	[CCode (cname = "LOCALEDIR")]
	public const string LOCALE_DIR;
}