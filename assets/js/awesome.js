const dropdownButtons = document.querySelectorAll('.dropdown-toggle');
let openMenu = null;

dropdownButtons.forEach(function (dropdownButton) {
  const dropdownMenu = dropdownButton.nextElementSibling;
  
  dropdownButton.addEventListener('click', function () {
    if (openMenu && openMenu !== dropdownMenu) {
      openMenu.classList.remove('show');
    }
    dropdownMenu.classList.toggle('show');
    openMenu = dropdownMenu;
  });
});

function toggleAmBack(button) {
    var amBack = button.parentNode;
    var data = amBack.querySelector('.data');
    if (data.classList.contains('hidden')) {
      data.classList.remove('hidden');
      button.innerText = '-';
    } else {
      data.classList.add('hidden');
      button.innerText = '+';
    }
  }
  
  
  