#!/usr/bin/env Rscript

#
#  This file is part of the `OmnipathR` R package
#
#  Copyright
#  2018-2022
#  Saez Lab, Uniklinik RWTH Aachen, Heidelberg University
#
#  File author(s): Alberto Valdeolivas
#                  Dénes Türei (turei.denes@gmail.com)
#                  Attila Gábor
#
#  Distributed under the MIT (Expat) License.
#  See accompanying file `LICENSE` or find a copy at
#      https://directory.fsf.org/wiki/License:Expat
#
#  Website: https://saezlab.github.io/omnipathr
#  Git repo: https://github.com/saezlab/OmnipathR
#


.onLoad <- function(libname, pkgname){

    omnipath_init_config()
    patch_logger_metavar()
    patch_logger_appender()
    omnipath_init_log(pkgname = pkgname)

    buildserver <- Sys.info()['user'] %in% c('biocbuild', 'omnipath')

    if(buildserver){

        omnipath_set_console_loglevel('trace')

    }

    omnipath_init_cache()

    if(buildserver) {

        logger::log_trace('Running on a build server, wiping cache.')
        omnipath_cache_wipe()

    }

    omnipath_init_db(pkgname)
    .load_magic_bytes(pkgname)
    .load_urls(pkgname)
    .load_id_types(pkgname)

    logger::log_info('Welcome to OmnipathR!')

    if(buildserver){

        omnipath_unlock_cache_db()

        logger::log_trace(
            'Cache locked: %s',
            file.exists(omnipath_cache_lock_path())
        )

    }

}
