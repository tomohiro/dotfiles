// Hyper configuration
// See https://hyper.is#cfg for all currently supported options.

module.exports = {
  config: {
    updateChannel: 'stable',

    // Disable webGL to fix Powerline spacing reggression
    // https://github.com/zeit/hyper/issues/3575
    webGLRenderer: false,

    // Font
    fontSize: 12,
    fontFamily: 'MesloLGS Nerd Font, Menlo for Powerline, monospace',
    fontWeight: 'normal',
    fontWeightBold: 'bold',

    // Text
    lineHeight: 1,
    letterSpacing: 0,

    // Cursor
    cursorColor: '#C5C8C6',
    cursorAccentColor: '#000',
    cursorShape: 'BLOCK',
    cursorBlink: true,

    // Appearance
    selectionColor: 'rgba(71, 75, 82, 0.3)',
    padding: '0px 5px 20px 5px',
    bell: 'SOUND',

    // Selected text will automatically be copied to the clipboard
    copyOnSelect: true,

    // Plugin configuration
    //  You can find awesome plugins here: https://github.com/bnb/awesome-hyper
    //
    // Hyperline - https://github.com/Hyperline/hyperline/
    hyperline: {
      plugins: [
        'battery',
        'ip',
        'network',
        'docker',
        'cpu',
        'memory',
        'spotify'
      ]
    },
  },

  plugins: [
    'hyper-one-dark',
    'hyper-search',
    'hyper-quit',
    'hyper-tab-icons-plus',
  ],

  // in development, you can create a directory under
  // `~/.hyper_plugins/local/` and include it here
  // to load it and avoid it being `npm install`ed
  localPlugins: [],

  keymaps: {},
};
