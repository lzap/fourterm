#! /usr/bin/env python
# -*-coding:utf-8 -*

APPNAME = 'valaterm'
VERSION = '0.2'

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

from waflib.Task import Task

class Translate(Task):
    def run(self):
        return self.exec_command('msgfmt %s -o %s' % (self.inputs[0].abspath(),
                                                      self.outputs[0].abspath()))

def build(bld):
    trans = Translate(env = bld.env)
    trans.set_inputs(bld.path.find_resource('po/fr/fr.po'))
    trans.set_outputs(bld.path.find_or_declare('po/fr/%s.mo' % (APPNAME)))

    bld.add_to_group(trans)

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

    bld.install_files('${PREFIX}/share/locale/fr/LC_MESSAGES', 'po/fr/%s.mo' % (APPNAME))
