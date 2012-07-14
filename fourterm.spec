Name:           fourterm
Version:        1.0.3
Release:        1%{?dist}
Summary:        Lightweight split-screen terminal emulator with vim key mappings

Group:          Development/Tools
License:        GPLv3+
URL:            https://github.com/lzap/fourterm
Source0:        http://lzap.fedorapeople.org/projects/fourterm/releases/%{name}-%{version}.tar.gz

#BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Requires:       libgee glib2 gtk3 vte3
Requires:       terminus-fonts

BuildRequires:  waf intltool gettext desktop-file-utils
BuildRequires:  vala-devel >= 0.12
BuildRequires:  pkgconfig(glib-2.0)
BuildRequires:  pkgconfig(gobject-2.0)
BuildRequires:  pkgconfig(gthread-2.0)
BuildRequires:  pkgconfig(gtk+-3.0)
BuildRequires:  pkgconfig(vte-2.90)
BuildRequires:  pkgconfig(gee-1.0)


%description
FourTerm is ultra-lightweight terminal emulator with vim-like keyboard shortcuts
for window navigation, active web and file links, search feature and sexy color
"Solarized" scheme with day/night fast switching. It is based on ValaTerm and
comparable to Terminator.


%prep
%setup -q


%build
waf configure --with-gtk3 --prefix=%{_prefix}
waf


%install
#%{__rm} -rf $RPM_BUILD_ROOT
waf install --destdir=$RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT%{_bindir}
cp build/%{name} $RPM_BUILD_ROOT%{_bindir}/%{name}

desktop-file-install --delete-original  \
        --dir $RPM_BUILD_ROOT%{_datadir}/applications   \
        --remove-category Application \
        $RPM_BUILD_ROOT%{_datadir}/applications/%{name}.desktop

%find_lang %{name}

%post
touch --no-create %{_datadir}/icons/hicolor &>/dev/null || :


%postun
if [ $1 -eq 0 ] ; then
    touch --no-create %{_datadir}/icons/hicolor &>/dev/null
    gtk-update-icon-cache %{_datadir}/icons/hicolor &>/dev/null || :
fi


%posttrans
gtk-update-icon-cache %{_datadir}/icons/hicolor &>/dev/null || :


%clean
#%{__rm} -rf $RPM_BUILD_ROOT


%files -f %{name}.lang
%doc AUTHORS COPYING INSTALL ChangeLog
%{_bindir}/%{name}
%{_datadir}/icons/hicolor/*/apps/%{name}.*
%{_datadir}/applications/%{name}.desktop


%changelog
* Sat Jul 14 2012 Lukas Zapletal <lzap+git@redhat.com> 1.0.3-1
- preparing upstream spec for fedora review

* Sat Jul 14 2012 Lukas Zapletal <lzap+git@redhat.com> 1.0.2-1
- adding version determination from git and dir
- correcting e-mail address in about box
- loading icon from data dir

* Sat Jul 14 2012 Lukas Zapletal <lzap+git@redhat.com> 1.0.1-1
- new package built with tito


* Sun Mar 26 2012 Lukas Zapletal <lzap+git@redhat.com> 1.0.0-1
- initial version
