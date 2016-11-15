function hideIt() {
  var hideme = document.querySelector('#hideme');
  var text = hideme.value;
  if (text === '') { return; }

  hideme.value = '';

  chrome.tabs.executeScript({
    code: 'Array.prototype.slice.apply(document.querySelectorAll(".source-name"))' +
      '.forEach(function(it){if(it.innerText.indexOf("' + text +
      '")!==-1){it.parentNode.parentNode.style.display="none";}});'
  });
}

function showAll(){
  chrome.tabs.executeScript({
    code: 'Array.prototype.slice.apply(document.querySelectorAll(".card")).forEach(function(it){it.style.display="";})'
  });
}

document.querySelector('#hideit').onclick = hideIt;
document.querySelector('#clearhide').onclick = showAll;
