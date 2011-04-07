#! /usr/bin/env python
# -*-coding:utf-8 -*

APPNAME = 'valaterm'
VERSION = '0.0.1'

release = False

if release is True:
    cflags = ['-pipe', '-O2']
    valaflags = '--thread'
else:
    cflags = ['-pipe', '-g']
    valaflags = ['--fatal-warnings', '-g']

top = '.'
out = 'build'

def options(opt):
    opt.load('compiler_c')
    opt.load('vala')

def configure(conf):
    conf.load('compiler_c')
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
    conf.env.PREFIX = '/usr'
    conf.env.LIBDIR = '/usr/lib'
    conf.env.BINDIR = '/usr/bin'

def build(bld):
    prog = bld.program(
        packages      = ['gtk+-2.0', 'vte'],
        target        = APPNAME,
        uselib        = ['gtk+', 'vte', 'glib'],
        defines       = 'GETTEXT_PACKAGE="{0}"'.format(APPNAME),
        cflags        = cflags,
        valaflags     = valaflags,
        source        = ['src/about.vala',
                         'src/contextmenu.vala',
                         'src/delegates.vala',
                         'src/main.vala',
                         'src/mainwindow.vala',
                         'src/menubar.vala',
                         'src/pictures.vala',
                         'src/terminal.vala'])
