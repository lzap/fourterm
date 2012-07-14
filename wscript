#! /usr/bin/env python
# encoding: utf-8
# Copyright © 2011 Jacques-Pascal Deplaix, 2012 Lukas Zapletal

APPNAME = 'fourterm'

top = '.'
out = 'build'

import waflib
import subprocess
import re
import os

def conf_get_git_revision():
    try:
        p = subprocess.Popen(['git', 'describe', '--abbrev=0', '--tags'], stdout=subprocess.PIPE, \
                stderr=subprocess.STDOUT, close_fds=False, env={'LANG' : 'C'})
        stdout = p.communicate()[0]

        if p.returncode == 0:
            lines = stdout.splitlines(True)
            m = re.match(r"^fourterm-(?P<version>\d+\.\d+\.\d+).*", lines[0])
            if m:
                return m.group('version').strip()
        return '1.0-git'
    except:
        return '1.0-git'

def conf_get_dir_revision():
    try:
        m = re.match(r".*fourterm-(?P<version>\d+\.\d+\.\d+).*", os.getcwd())
        if m:
            return m.group('version').strip()
        return '1.0-git'
    except:
        return '1.0-git'

VERSION = conf_get_dir_revision()

def options(opt):
    opt.load(['compiler_c', 'vala'])

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
        conf.env.VALAFLAGS.extend(['--define=GTK3'])

    conf.load('vala', funs = '')
    conf.check_vala(min_version = conf.options.with_gtk3 and (0, 13, 2) or (0, 10, 0))

    if conf.env.VALAC_VERSION >= (0, 12, 1):
        conf.env.VALAFLAGS.extend(['--define=VALAC_SUP_0_12_1'])

    glib_package_version = conf.env.VALAC_VERSION >= (0, 12, 0) and '2.16.0' or '2.14.0'
    gtk_package_name = conf.options.with_gtk3 and 'gtk+-3.0' or 'gtk+-2.0'
    vte_package_name = conf.options.with_gtk3 and 'vte-2.90' or 'vte'

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
        package         = 'gee-1.0',
        uselib_store    = 'GEE',
        atleast_version = '0.6.4',
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
        conf.env.CFLAGS.extend(['-ggdb3'])
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

    bld.program(
        packages      = [bld.env.with_gtk3 and 'vte-2.90' or 'vte', 'config', 'posix', 'gee-1.0'],
        vapi_dirs     = 'vapi',
        target        = APPNAME,
        uselib        = ['GLIB', 'GOBJECT', 'GTHREAD', 'GEE', 'GTK', 'VTE'],
        source        = ['src/about.vala',
                         'src/check-button.vala',
                         'src/check-menu-item.vala',
                         'src/colors.vala',
                         'src/color-button.vala',
                         'src/config-file.vala',
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
                         'src/settings.vala',
                         'src/spin-button.vala',
                         'src/grid-manager.vala',
                         'src/terminal.vala',
                         'src/matchers.vala'])
    # install desktop file
    bld.install_files('${PREFIX}/share/applications', 'data/' + APPNAME + '.desktop')
   
    # install icons
    ICON_PATH='${PREFIX}/share/icons/hicolor/'
    bld.install_files(ICON_PATH + 'scalable/apps', 'data/icons/scalable/apps/' + APPNAME + '.svg');
    bld.install_files(ICON_PATH + '16x16/apps', 'data/icons/16x16/apps/' + APPNAME + '.png');
    bld.install_files(ICON_PATH + '22x22/apps', 'data/icons/22x22/apps/' + APPNAME + '.png');
    bld.install_files(ICON_PATH + '24x24/apps', 'data/icons/24x24/apps/' + APPNAME + '.png');
    bld.install_files(ICON_PATH + '32x32/apps', 'data/icons/32x32/apps/' + APPNAME + '.png');
    bld.install_files(ICON_PATH + '48x48/apps', 'data/icons/48x48/apps/' + APPNAME + '.png');
    bld.install_files(ICON_PATH + '64x64/apps', 'data/icons/64x64/apps/' + APPNAME + '.png');
    bld.install_files(ICON_PATH + '128x128/apps', 'data/icons/128x128/apps/' + APPNAME + '.png');

def dist(ctx):
    ctx.excl = '**/.*'
