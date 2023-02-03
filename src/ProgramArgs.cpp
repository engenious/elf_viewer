//
// SPDX-License-Identifier: MIT
// Copyright (c) Contributors to the elf_viewer Project.
//

#include <cxxopts.hpp>

#include "ApplicationInfo.h"
#include "ProgramArgs.h"

namespace elfviewer
{

//-----------------------------------------------------------------------------
// Statics
//-----------------------------------------------------------------------------

constexpr static const char* cFilenameArgName = "filename";
constexpr static const char* cHelpArgName = "help";
constexpr static const char* cVersionArgName = "version";

//-----------------------------------------------------------------------------
// Helpers
//-----------------------------------------------------------------------------

using OptionType = std::shared_ptr< const cxxopts::Value >;

static void sAddOption(
    cxxopts::OptionAdder& io_options,
    const std::string& i_longOption,
    char i_shortOption,
    const std::string& i_description,
    const OptionType& i_type = cxxopts::value< bool >() )
{
    std::stringstream stringBuffer;
    stringBuffer << i_shortOption << "," << i_longOption;
    io_options( stringBuffer.str(), i_description, i_type );
}


//-----------------------------------------------------------------------------
// Arg parsing entry point
//-----------------------------------------------------------------------------

ParsedArgs parseArgs( int i_argc, const char** i_argv )
{
    ParsedArgs toReturn;

    cxxopts::Options options( getApplicationNameString(), getApplicationDescriptionString() );
    cxxopts::OptionAdder adder = options.add_options();

    sAddOption( adder, cHelpArgName, 'h', "Display this help text and exit" );
    sAddOption( adder, cVersionArgName, 'V', "Display version info and exit" );
    adder( cFilenameArgName, "The ELF file to view", cxxopts::value< std::string >() );

    options.parse_positional( { cFilenameArgName } );
    options.positional_help( cFilenameArgName );

    const cxxopts::ParseResult parseOutput = options.parse( i_argc, i_argv );

    toReturn.m_helpMessage = options.help();

    if ( parseOutput.count( cHelpArgName ) > 0UL )
    {
        toReturn.m_showHelp = true;
        return toReturn;
    }

    if ( parseOutput.count( cVersionArgName ) > 0UL )
    {
        toReturn.m_showVersion = true;
        return toReturn;
    }

    if ( parseOutput.count( cFilenameArgName ) == 0UL )
    {
        toReturn.m_errorDetected = true;
        toReturn.m_errorMessage = "Must pass an ELF file to parse";
        return toReturn;
    }

    toReturn.m_filename = parseOutput[ cFilenameArgName ].as< std::string >();

    return toReturn;
}

} // namespace elfviewer
