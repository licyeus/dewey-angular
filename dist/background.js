// Called when the user clicks on the browser action.
chrome.browserAction.onClicked.addListener(function(tab) {
  console.log('launching dewey', tab);
  chrome.windows.create('index.html', {
    id: "DeweyWindow",
    innerBounds: {
      width: 800,
      height: 500,
      minWidth: 500,
      minHeight: 600
    },
    frame: 'none'
  });
});

/*
chrome.runtime.onInstalled.addListener(function() {
  console.log('installed');
});

chrome.runtime.onSuspend.addListener(function() { 
  // Do some simple clean-up tasks.
});
*/