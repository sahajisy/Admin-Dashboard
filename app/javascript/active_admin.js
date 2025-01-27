document.addEventListener('DOMContentLoaded', function() {
    const jlptLevelSelect = document.getElementById('jlpt_level_select');
    const balanceInput = document.getElementById('balance_input');
  
    if (jlptLevelSelect && balanceInput) {
      jlptLevelSelect.addEventListener('change', function() {
        let amount;
        switch (jlptLevelSelect.value) {
          case 'N5':
            amount = 10000;
            break;
          case 'N4':
            amount = 12000;
            break;
          case 'N3':
            amount = 14000;
            break;
          case 'N2':
            amount = 16000;
            break;
          default:
            amount = 0;
        }
        balanceInput.value = amount;
      });
    }
  });
  