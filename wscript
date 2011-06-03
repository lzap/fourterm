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
    conf.env.CFLAGS = list()
    conf.env.VALAFLAGS = list()

    conf.load(['compiler_c', 'gnu_dirs', 'intltool'])
    conf.load('vala', funs = '')
    conf.check_vala(min_version = (0, 10, 0))

    if conf.env.VALAC_VERSION >= (0, 12, 1):
        conf.env.VALAFLAGS.extend(['--define=VALAC_SUP_0_12_1'])

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
        conf.env.VALAFLAGS.extend(['--define=VTE_SUP_0_26'])
    except waflib.Errors.ConfigurationError:
        conf.check_cfg(
            package         = 'vte',
            uselib_store    = 'vte',
            max_version     = '0.26',
            atleast_version = '0.20',
            args            = '--cflags --libs')

    # Add /usr/local/include for compilation under OpenBSD
    conf.env.CFLAGS.extend(['-pipe', '-I/usr/local/include', '-include', 'config.h'])
    conf.define('GETTEXT_PACKAGE', APPNAME)
    conf.define('VERSION', VERSION)

    if conf.options.debug == True:
        conf.env.CFLAGS.extend(['-g'])
        conf.env.VALAFLAGS.extend(['--fatal-warnings', '-g', '--define=DEBUG'])
    else:
        conf.env.CFLAGS.extend(['-O2'])
        conf.env.VALAFLAGS.extend(['--thread'])

    conf.write_config_header('config.h')

def build(bld):
    bld(features = 'intltool_po', appname = APPNAME, podir = 'po')

    bld.program(
        packages      = ['gtk+-2.0', 'vte', 'config', 'posix'],
        vapi_dirs     = 'vapi',
        target        = APPNAME,
        uselib        = ['gtk+', 'vte', 'glib', 'gthread'],
        source        = ['src/about.vala',
                         'src/check-button.vala',
                         'src/check-menu-item.vala',
                         'src/colors.vala',
                         'src/color-button.vala',
                         'src/config-file.vala',
                         'src/configurations-window.vala',
                         'src/context-menu.vala',
                         'src/default-dialog.vala',
                         'src/font-button.vala',
                         'src/icons.vala',
                         'src/image-menu-item.vala',
                         'src/main.vala',
                         'src/main-window.vala',
                         'src/menu-bar.vala',
                         'src/menu-item.vala',
                         'src/message-dialog.vala',
                         'src/parameter-box.vala',
                         'src/pictures.vala',
                         'src/settings.vala',
                         'src/spin-button.vala',
                         'src/terminal.vala'])
