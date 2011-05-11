#! /usr/bin/env python
# -*-coding:utf-8 -*

APPNAME = 'valaterm'
VERSION = '0.2'

release = False
# Add /usr/local/include for compilation under OpenBSD
cflags = ['-pipe', '-I/usr/local/include']

if release is True:
    cflags.append('-O2')
    valaflags = '--thread'
else:
    cflags.append('-g')
    valaflags = ['--fatal-warnings', '-g']

top = '.'
out = 'build'

def options(opt):
    opt.load('compiler_c')
    opt.load('vala')

def configure(conf):
    conf.load(['compiler_c', 'gnu_dirs', 'intltool'])
    conf.load('vala', funs = '')
    conf.check_vala(min_version = (0, 12, 0))
    conf.check_cfg(
        package         = 'glib-2.0',
        uselib_store    = 'glib',
        atleast_version = '2.10.0',
        args            = '--cflags --libs')
    conf.check_cfg(
        package         = 'gtk+-2.0',
        uselib_store    = 'gtk+',
        atleast_version = '2.10.0',
        args            = '--cflags --libs')
    conf.check_cfg(
        package         = 'vte',
        uselib_store    = 'vte',
        atleast_version = '0.26',
        args            = '--cflags --libs')

    if release == True:
        conf.env.LOCALEDIR = '/usr/share/locale'
        conf.env.BINDIR = '/usr/bin'

def build(bld):
    bld(features = 'intltool_po', appname = APPNAME, podir = 'po')

    prog = bld.program(
        packages      = ['gtk+-2.0', 'vte'],
        target        = APPNAME,
        uselib        = ['gtk+', 'vte', 'glib'],
        defines       = 'GETTEXT_PACKAGE="%s"' % (APPNAME),
        cflags        = cflags,
        valaflags     = valaflags,
        source        = ['src/about.vala',
                         'src/config-file.vala',
                         'src/configurations-window.vala',
                         'src/context-menu.vala',
                         'src/delegates.vala',
                         'src/main.vala',
                         'src/main-window.vala',
                         'src/menu-bar.vala',
                         'src/pictures.vala',
                         'src/setting-key.vala',
                         'src/settings.vala',
                         'src/terminal.vala'])
