vimfx.addKeyOverrides([location => location.hostname === 'feedly.com', ['j', 'k', 'v']],
                      [location => location.hostname === 'facebook.com', ['j', 'k']],
                      [location => location.hostname === 'plus.google.com', ['j', 'k']]);
