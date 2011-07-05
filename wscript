#! /usr/bin/env python
# encoding: utf-8
# Copyright © 2011 Jacques-Pascal Deplaix

APPNAME = 'valaterm'
VERSION = '0.4.1'

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

    opt.add_option('--with-gtk3',
                   help = 'Compile with Gtk 3.0 instead of Gtk 2.0 (Experimental mode).'
                   ' Works only with a modified vte.deps',
                   action = 'store_true',
                   default = False)

    opt.add_option('--disable-nls',
                   help = 'Disable internationalisation (text in english).',
                   action = 'store_true',
                   default = False)

def configure(conf):
    conf.env.CFLAGS = list()
    conf.env.VALAFLAGS = list()

    if conf.options.disable_nls == True:
        conf.load(['compiler_c', 'gnu_dirs'])
    else:
        conf.load(['compiler_c', 'gnu_dirs', 'intltool'])

    conf.load('vala', funs = '')
    conf.check_vala(min_version = (0, 10, 0))

    if conf.env.VALAC_VERSION >= (0, 12, 1):
        conf.env.VALAFLAGS.extend(['--define=VALAC_SUP_0_12_1'])

    if conf.env.VALAC_VERSION >= (0, 12, 0):
        glib_package_version = '2.16.0'
    else:
        glib_package_version = '2.14.0'

    if conf.options.with_gtk3 == True:
        gtk_package_name = 'gtk+-3.0'
        vte_package_name = 'vte-2.90'
    else:
        gtk_package_name = 'gtk+-2.0'
        vte_package_name = 'vte'

    conf.check_cfg(
        package         = 'glib-2.0',
        uselib_store    = 'GLIB',
        atleast_version = glib_package_version,
        args            = '--cflags --libs')

    conf.check_cfg(
        package         = 'gobject-2.0',
        uselib_store    = 'GOBJECT',
        atleast_version = glib_package_version,
        args            = '--cflags --libs')

    conf.check_cfg(
        package         = 'gthread-2.0',
        uselib_store    = 'GTHREAD',
        atleast_version = glib_package_version,
        args            = '--cflags --libs')

    conf.check_cfg(
        package         = gtk_package_name,
        uselib_store    = 'GTK',
        atleast_version = '2.16',
        args            = '--cflags --libs')

    try:
        conf.check_cfg(
            package         = vte_package_name,
            uselib_store    = 'VTE',
            atleast_version = '0.26',
            args            = '--cflags --libs')
        conf.env.VALAFLAGS.extend(['--define=VTE_SUP_0_26'])
    except waflib.Errors.ConfigurationError:
        conf.check_cfg(
            package         = 'vte',
            uselib_store    = 'VTE',
            max_version     = '0.26',
            atleast_version = '0.20',
            args            = '--cflags --libs')

    # Add /usr/local/include for compilation under OpenBSD
    conf.env.CFLAGS.extend(['-pipe', '-I/usr/local/include', '-include', 'config.h'])
    conf.define('VERSION', VERSION)

    if conf.options.disable_nls == False:
        conf.define('GETTEXT_PACKAGE', APPNAME)
        conf.env.VALAFLAGS.extend(['--define=ENABLE_NLS'])

    if conf.options.debug == True:
        conf.env.CFLAGS.extend(['-g'])
        conf.env.VALAFLAGS.extend(['--fatal-warnings', '-g', '--define=DEBUG'])
    else:
        conf.env.CFLAGS.extend(['-O2'])
        conf.env.VALAFLAGS.extend(['--thread'])

    conf.write_config_header('config.h')

def build(bld):
    if bld.options.disable_nls == False:
        bld(features = 'intltool_po', appname = APPNAME, podir = 'po')

    bld.program(
        packages      = ['vte', 'config', 'posix'],
        vapi_dirs     = 'vapi',
        target        = APPNAME,
        uselib        = ['GLIB', 'GOBJECT', 'GTHREAD', 'GTK', 'VTE'],
        source        = ['src/about.vala',
                         'src/check-button.vala',
                         'src/check-menu-item.vala',
                         'src/colors.vala',
                         'src/color-button.vala',
                         'src/config-file.vala',
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
                         'src/parameters-window.vala',
                         'src/parameter-box.vala',
                         'src/pictures.vala',
                         'src/settings.vala',
                         'src/spin-button.vala',
                         'src/terminal.vala'])
