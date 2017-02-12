vimfx.addKeyOverrides([location => location.hostname === 'feedly.com', ['j', 'k', 'v']],
                      [location => location.hostname === 'www.facebook.com', ['j', 'k']],
                      [location => location.hostname === 'plus.google.com', ['j', 'k']]);
