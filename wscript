#! /usr/bin/env python
# -*-coding:utf-8 -*

APPNAME = 'valaterm'
VERSION = '0.2'

top = '.'
out = 'build'

def options(opt):
    opt.load('compiler_c')
    opt.load('vala')

    opt.add_option('--debug',
                   help = 'Debug mode',
                   action = 'store_true',
                   default = False)

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

    # Add /usr/local/include for compilation under OpenBSD
    conf.env.CFLAGS = ['-pipe', '-I/usr/local/include', '-include', 'config.h']
    conf.define('GETTEXT_PACKAGE', APPNAME)
    conf.define('VERSION', VERSION)
    conf.write_config_header('config.h')

    if conf.options.debug == True:
        conf.env.CFLAGS.append('-g')
        conf.env.VALAFLAGS = ['--fatal-warnings', '-g']
    else:
        conf.env.CFLAGS.append('-O2')
        conf.env.VALAFLAGS = ['--thread']

def build(bld):
    bld(features = 'intltool_po', appname = APPNAME, podir = 'po')

    bld.program(
        packages      = ['gtk+-2.0', 'vte', 'config', 'posix'],
        vapi_dirs     = 'vapi',
        target        = APPNAME,
        uselib        = ['gtk+', 'vte', 'glib'],
        source        = ['src/about.vala',
                         'src/colors.vala',
                         'src/config-file.vala',
                         'src/configurations-window.vala',
                         'src/context-menu.vala',
                         'src/default-dialog.vala',
                         'src/delegates.vala',
                         'src/image-menu-item.vala',
                         'src/main.vala',
                         'src/main-window.vala',
                         'src/menu-bar.vala',
                         'src/menu-item.vala',
                         'src/parameter-box.vala',
                         'src/pictures.vala',
                         'src/settings.vala',
                         'src/terminal.vala'])
