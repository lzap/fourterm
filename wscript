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
                   ' Works only with Vala >= 0.13.2',
                   action = 'store_true',
                   default = False)

    opt.add_option('--disable-nls',
                   help = 'Disable internationalisation (text in english).',
                   action = 'store_true',
                   default = False)

def configure(conf):
    conf.env.CFLAGS = list()
    conf.env.VALAFLAGS = list()
    conf.env.LINKFLAGS = list()

    conf.load(['compiler_c', 'gnu_dirs'])

    if conf.options.disable_nls != True:
        conf.load(['intltool'])

    if conf.options.with_gtk3 == True:
        min_vala_version = (0, 13, 2)
    else:
        min_vala_version = (0, 10, 0)

    conf.load('vala', funs = '')
    conf.check_vala(min_version = min_vala_version)

    if conf.env.VALAC_VERSION >= (0, 12, 1):
        conf.env.VALAFLAGS.extend(['--define=VALAC_SUP_0_12_1'])

    if conf.env.VALAC_VERSION >= (0, 12, 0):
        glib_package_version = '2.16.0'
    else:
        glib_package_version = '2.14.0'

    if conf.options.with_gtk3 == True:
        conf.env.VALAFLAGS.extend(['--define=GTK3'])
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
            package         = vte_package_name,
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
        conf.env.CFLAGS.extend(['-g3', '-ggdb3'])
        conf.env.VALAFLAGS.extend(['-g', '--define=DEBUG'])
    else:
        conf.env.CFLAGS.extend(['-O2'])
        conf.env.VALAFLAGS.extend(['--thread'])
        conf.env.LINKFLAGS.extend(['-Wl,-O1', '-s'])

    conf.env.debug = conf.options.debug
    conf.env.with_gtk3 = conf.options.with_gtk3
    conf.env.disable_nls = conf.options.disable_nls

    conf.write_config_header('config.h')

def build(bld):
    if bld.env.disable_nls == False:
        bld(features = 'intltool_po', appname = APPNAME, podir = 'po')

    if bld.env.with_gtk3 == True:
        vte_name = 'vte-2.90'
    else:
        vte_name = 'vte'

    bld.program(
        packages      = [vte_name, 'config', 'posix'],
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

def dist(ctx):
    ctx.excl = '**/.*'
