#! /usr/bin/env python
# -*-coding:utf-8 -*

APPNAME = 'valaterm'
VERSION = '0.3'

top = '.'
out = 'build'

import waflib

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
        atleast_version = '2.6',
        args            = '--cflags --libs')
    conf.check_cfg(
        package         = 'gthread-2.0',
        uselib_store    = 'gthread',
        args            = '--cflags --libs')
    conf.check_cfg(
        package         = 'gtk+-2.0',
        uselib_store    = 'gtk+',
        atleast_version = '2.16',
        args            = '--cflags --libs')
    try:
        conf.check_cfg(
            package         = 'vte',
            uselib_store    = 'vte',
            atleast_version = '0.26',
            args            = '--cflags --libs')
        conf.env.VALAFLAGS = ['--define=VTE_SUP_0_26']
    except waflib.Errors.ConfigurationError:
        conf.check_cfg(
            package         = 'vte',
            uselib_store    = 'vte',
            max_version     = '0.26',
            atleast_version = '0.20',
            args            = '--cflags --libs')
        conf.env.VALAFLAGS = ['']

    # Add /usr/local/include for compilation under OpenBSD
    conf.env.CFLAGS = ['-pipe', '-I/usr/local/include', '-include', 'config.h']
    conf.define('GETTEXT_PACKAGE', APPNAME)
    conf.define('VERSION', VERSION)
    conf.write_config_header('config.h')

    if conf.options.debug == True:
        conf.env.CFLAGS.append('-g')
        conf.env.VALAFLAGS.append('--fatal-warnings')
        conf.env.VALAFLAGS.append('-g')
        conf.env.VALAFLAGS.append('--define=DEBUG')
    else:
        conf.env.CFLAGS.append('-O2')
        conf.env.VALAFLAGS.append('--thread')

def build(bld):
    bld(features = 'intltool_po', appname = APPNAME, podir = 'po')

    bld.program(
        packages      = ['gtk+-2.0', 'vte', 'config', 'posix'],
        vapi_dirs     = 'vapi',
        target        = APPNAME,
        uselib        = ['gtk+', 'vte', 'glib', 'gthread'],
        source        = ['src/about.vala',
                         'src/colors.vala',
                         'src/config-file.vala',
                         'src/configurations-window.vala',
                         'src/context-menu.vala',
                         'src/default-dialog.vala',
                         'src/image-menu-item.vala',
                         'src/main.vala',
                         'src/main-window.vala',
                         'src/menu-bar.vala',
                         'src/menu-item.vala',
                         'src/parameter-box.vala',
                         'src/pictures.vala',
                         'src/settings.vala',
                         'src/terminal.vala'])
