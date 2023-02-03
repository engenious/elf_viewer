//
// SPDX-License-Identifier: MIT
// Copyright (c) Contributors to the elf_viewer Project.
//

#pragma once

#include <string>

namespace elfviewer
{

//-----------------------------------------------------------------------------

struct ParsedArgs
{
    std::string     m_filename;
    std::string     m_helpMessage;
    std::string     m_errorMessage;
    bool            m_showVersion = false;
    bool            m_showHelp = false;
    bool            m_errorDetected = false;
};

//-----------------------------------------------------------------------------

ParsedArgs parseArgs( int i_argc, const char** i_argv );

} // namespace elfviewer
