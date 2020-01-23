#!/usr/bin/env node

'use strict';

const spawnSync = require( 'child_process' ).spawnSync;
const fs = require( 'fs' );
const path = require( 'path' );

const spawn = ( ...args ) => spawnSync( ...args ).stdout.toString().trim();

const colors = {
    black: ( str ) => `\x1b[30m${str}\x1b[0m`,
    red: ( str ) => `\x1b[31m${str}\x1b[0m`,
    green: ( str ) => `\x1b[32m${str}\x1b[0m`,
    yellow: ( str ) => `\x1b[33m${str}\x1b[0m`,
    blue: ( str ) => `\x1b[34m${str}\x1b[0m`,
    magenta: ( str ) => `\x1b[35m${str}\x1b[0m`,
    cyan: ( str ) => `\x1b[36m${str}\x1b[0m`,
    white: ( str ) => `\x1b[37m${str}\x1b[0m`,

    brightBlack: ( str ) => `\x1b[1;30m${str}\x1b[0m`,
    brightRed: ( str ) => `\x1b[1;31m${str}\x1b[0m`,
    brightGreen: ( str ) => `\x1b[1;32m${str}\x1b[0m`,
    brightYellow: ( str ) => `\x1b[1;33m${str}\x1b[0m`,
    brightBlue: ( str ) => `\x1b[1;34m${str}\x1b[0m`,
    brightMagenta: ( str ) => `\x1b[1;35m${str}\x1b[0m`,
    brightCyan: ( str ) => `\x1b[1;36m${str}\x1b[0m`,
    brightWhite: ( str ) => `\x1b[1;37m${str}\x1b[0m`,

    reset: ( str ) => `${"`tput sgr0`"}${str}${"`tput sgr0`"}`,
};

const parseFileStatuses = ( fileStatuses = [] ) => {
    return fileStatuses.reduce( ( { modified = 0, staged = 0, untracked = 0, conflict = 0 }, fileStatus ) => {
        const status = fileStatus.slice( 0, 2 );

        if ( status === '??' ) {
            untracked += 1;
            return { modified, staged, untracked, conflict };
        }

        const [ x, y ] = status;

        if ( status === 'DD' || status === 'AA' || x === 'U' || y === 'U' ) {
            conflict += 1;
            return { modified, staged, untracked, conflict };
        }

        if ( y === 'M' || y === 'D' ) {
            modified += 1;
            return { modified, staged, untracked, conflict };
        }

        staged += 1;

        return { modified, staged, untracked, conflict };
    }, { modified: 0, staged: 0, untracked: 0, conflict: 0 } );
}

const isGitRepo = () => spawn( 'git', [ 'rev-parse', '--is-inside-work-tree' ] ) !== "";

const getStash = () => {
    const gitDir = spawn( 'git', [ 'rev-parse', '--absolute-git-dir' ] );
    const stashPath = path.join( gitDir, '/logs/refs/stash' );

    if (!fs.existsSync(stashPath)) { return 0; }

    const content = fs.readFileSync( stashPath, 'ascii' );

    return content.split( '\n' ).length - 1;
}

const getBranchDivergenceDetails = ( { ahead, behind } ) => {
    const divergenceAhead = ahead ? colors.brightCyan( ` ↥·${ahead}` ) : '';
    const divergenceBehind = behind ? colors.brightCyan( ` ⤓·${behind}` ) : '';

    return `${divergenceAhead}${divergenceBehind}`;
}

const getBranchDetails = ( statusHeader ) => {
    const branchRegex = /^## (?<local>.*?)(\.{3}(?<remote>.*?))?( \[(ahead (?<ahead>\d{1,}))? ?(behind (?<behind>\d{1,}))?\])?$/;

    const { groups: { local, remote = colors.brightRed( "⊘ " ), ahead, behind } } = statusHeader.match( branchRegex );

    const localDetails = colors.brightGreen( ` ${local}` );
    const remoteDetails = colors.brightBlue( `⭜ ${remote}` );

    const divergenceDetails = getBranchDivergenceDetails( { ahead, behind } );

    return `${localDetails} { ${remoteDetails} }${divergenceDetails}`;
}

const getFormattedStatus = ( { staged, conflict, modified, untracked, stash } ) => {
    const stagedStatus = staged !== 0 ? colors.brightYellow( `  ☑  ⟹  ${staged}` ) : '';
    const conflictStatus = conflict !== 0 ? colors.brightRed( `  ⛕  ⟹  ${conflict}` ) : '';
    const modifiedStatus = modified !== 0 ? colors.yellow( `  △  ⟹  ${modified}` ) : '';
    const untrackedStatus = untracked !== 0 ? colors.brightGreen( `  ∉ ⟹  ${untracked}` ) : '';
    const stashStatus = stash !== 0 ? colors.cyan( `  Ξϟ ⟹  ${stash}` ) : '';

    return `${stagedStatus}${conflictStatus}${modifiedStatus}${untrackedStatus}${stashStatus}`;
}

const getGitStatusDetails = ( fileStatuses ) => {
    const { modified, staged, untracked, conflict } = parseFileStatuses( fileStatuses );
    const stash = getStash();

    const clean = modified + staged + untracked + conflict + stash === 0;

    if ( clean ) { return colors.green( '  ✔ ' ); }

    return getFormattedStatus( { modified, staged, untracked, conflict, stash } );
}

function getGitDetails() {
    if ( !isGitRepo() ) {
        return ` [ ${colors.brightRed( '!⛓ ' )} ] `;
    }

    const status = spawn( 'git', [ 'status', '-sb' ] );
    const [ header, ...fileStatuses ] = status.split( '\n' );

    const branchDetails = getBranchDetails( header );
    const statusDetails = getGitStatusDetails( fileStatuses );

    return ` [ ${branchDetails}  ▎${statusDetails} ] `;
}

// -------------------------------------------------------------------------------------------------

const [ lastStatus ] = process.argv.slice( 2 );
const lastStatusDetails = lastStatus === '0' ? colors.green( '✔  ' ) : colors.red( '✘  ' );

const pwd = spawn( 'pwd' );
const pwdDetails = colors.yellow( pwd );

const gitDetails = getGitDetails() || ` [ ${isGitRepo()} ] `;

const options = {
    month: 'short',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour12: false
};
const ts = new Intl.DateTimeFormat( undefined, options ).format( new Date() );
const tsDetails = colors.brightBlue( `(${ts})` );

process.stdout.write( `\n${lastStatusDetails}${pwdDetails}${gitDetails}${tsDetails}\n⮑  ` );
