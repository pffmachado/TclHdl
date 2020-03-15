#------------------------------------------------------------------------------
#-- Copyright (c) 2020 TclHdl
#-- 
#-- Permission is hereby granted, free of charge, to any person obtaining a copy
#-- of this software and associated documentation files (the "Software"), to deal
#-- in the Software without restriction, including without limitation the rights
#-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#-- copies of the Software, and to permit persons to whom the Software is
#-- furnished to do so, subject to the following conditions:
#-- 
#-- The above copyright notice and this permission notice shall be included in all
#-- copies or substantial portions of the Software.
#-- 
#-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#-- SOFTWARE.
#------------------------------------------------------------------------------
#-- Project  : TclHdl - Open HDL hub
#-- Author   : Paulo Machado <pffmachado@yahoo.com> 
#-- Filename : Makefile
#------------------------------------------------------------------------------
#-- File Description:
#--
#--
#--
#--
#------------------------------------------------------------------------------
#-- ChangeLog:
#--
#--
#--
#--
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
#-- Setup Environment
#------------------------------------------------------------------------------
PATH_ROOT	= $(PWD)
PATH_SRC	= $(PATH_ROOT)/src
PATH_TOOL	= $(PATH_ROOT)/tool
PATH_CMAKE	= $(PATH_ROOT)/cmake
PATH_DOCS	= $(PATH_ROOT)/docs

PATH_DOXYGEN = $(PATH_DOCS)/doxygen
PATH_SPHINX  = $(PATH_DOCS)/sphinx

PATH_SPHINX_BUILD       = $(PATH_SPHINX)/build
PATH_SPHINX_BUILD_HTML  = $(PATH_SPHINX_BUILD)/html

#------------------------------------------------------------------------------
#-- Generate Documentation
#------------------------------------------------------------------------------

sphinx:
	cd $(PATH_SPHINX); \
		make html; \
		cp -r $(PATH_SPHINX_BUILD_HTML)/* $(PATH_DOCS); \
		rm -rf $(PATH_SPHINX_BUILD)

