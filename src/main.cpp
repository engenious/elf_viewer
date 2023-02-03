//
// SPDX-License-Identifier: MIT
// Copyright (c) Contributors to the elf_viewer Project.
//

#include <cstdlib>
#include <iostream>

#include "ApplicationInfo.h"
#include "ProgramArgs.h"

//-----------------------------------------------------------------------------
// Main
//-----------------------------------------------------------------------------

int main( int i_argc, const char** i_argv )
{
    const elfviewer::ParsedArgs args = elfviewer::parseArgs( i_argc, i_argv );

    if ( args.m_showHelp )
    {
        std::cout << args.m_helpMessage << std::endl;
        return EXIT_SUCCESS;
    }

    if ( args.m_showVersion )
    {
        std::cout << elfviewer::getApplicationName() << " version " << elfviewer::getFullVersion() << std::endl;
        return EXIT_SUCCESS;
    }

    if ( args.m_errorDetected )
    {
        std::cerr << args.m_errorMessage << std::endl;
        std::cout << args.m_helpMessage << std::endl;
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}