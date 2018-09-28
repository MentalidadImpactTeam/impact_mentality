$(document).ready(function() {
    var cleave = new Cleave('#cuenta_num', {
        creditCard: true,
        onCreditCardTypeChanged: function(type) {
            // update UI ...
        }
    });
});