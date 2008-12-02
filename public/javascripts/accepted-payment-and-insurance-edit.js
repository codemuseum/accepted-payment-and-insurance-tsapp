var AcceptedPaymentAndInsuranceEdit = {
  init: function() {
    $$('div.app-accepted-payment-and-insurance').each(function(el) {
      var customPaymentHtml = el.select('.new-custom-payment-code')[0].remove().innerHTML;
      var customInsuranceHtml = el.select('.new-custom-insurance-code')[0].remove().innerHTML;
      
      var paymentSelector = AcceptedPaymentAndInsuranceEdit.registerPopup(el.select('.payment-selector')[0]);
      var insuranceSelector = AcceptedPaymentAndInsuranceEdit.registerPopup(el.select('.insurance-selector')[0]);
      el.select('a.add-payment').each(function(a) { a.observe('click', function() { paymentSelector.popup(); }); });
      el.select('a.add-insurance').each(function(a) { a.observe('click', function() { insuranceSelector.popup(); }); });
      
      var paymentTypes = el.select('div.payment-types')[0];
      var insuranceTypes = el.select('div.insurance-types')[0];
      
      // Save the names of the builtin ones
      el.ancestors().detect(function(anc) { return anc.tagName == 'FORM' }).observe('submit', function(ev) {
        var paymentInput = $(document.createElement('div')).update(customPaymentHtml).select('input')[0].remove();
        paymentTypes.select('.type.builtin').each(function(t) { AcceptedPaymentAndInsuranceEdit.setValue(t, paymentInput); });
        
        var insuranceInput = $(document.createElement('div')).update(customInsuranceHtml).select('input')[0].remove();
        insuranceTypes.select('.type.builtin').each(function(t) { AcceptedPaymentAndInsuranceEdit.setValue(t, insuranceInput); });
      });
      
      // Allow the custom button to create a new text field where the user can type in.
      
      paymentSelector.el.select('.type.custom').each(function(p) { p.observe('click', function() {
        paymentSelector.popdown();
        var newEl=$(document.createElement('div'));
        newEl.update(customPaymentHtml);
        newEl = newEl.firstDescendant().remove();
        paymentTypes.appendChild(newEl);
        newEl.select('input')[0].focus();
        
        newEl.select('.remove a')[0].observe('click', function() { newEl.remove(); });
      }); });

      insuranceSelector.el.select('.type.custom').each(function(p) { p.observe('click', function() {
        insuranceSelector.popdown();
        var newEl=$(document.createElement('div'));
        newEl.update(customInsuranceHtml);
        newEl = newEl.firstDescendant().remove();
        insuranceTypes.appendChild(newEl);
        newEl.select('input')[0].focus();
        
        newEl.select('.remove a')[0].observe('click', function() { newEl.remove(); });
      }); });
      
      
      paymentSelector.el.select('.type.builtin').each(function(p) { 
        AcceptedPaymentAndInsuranceEdit.observeBuiltinAdd(p, paymentSelector, paymentTypes); 
      });
      
      insuranceSelector.el.select('.type.builtin').each(function(p) { 
        AcceptedPaymentAndInsuranceEdit.observeBuiltinAdd(p, insuranceSelector, insuranceTypes);
      });
      
      
      // Setup every builtin element to be removable back to the selector from whence it came
      
      el.select('.payment-types .type.builtin').each(function (t) { 
        AcceptedPaymentAndInsuranceEdit.observeBuiltinRemove(t, paymentSelector, paymentTypes); 
      });
      
      el.select('.insurance-types .type.builtin').each(function (t) { 
        AcceptedPaymentAndInsuranceEdit.observeBuiltinRemove(t, insuranceSelector, insuranceTypes); 
      });
      
      // Setup every custom element to be removable
      el.select('.payment-types .type.custom').each(function (t) { 
        t.select('.remove a')[0].observe('click', function() { t.remove(); });
      });
      
      el.select('.insurance-types .type.custom').each(function (t) { 
        t.select('.remove a')[0].observe('click', function() { t.remove(); });
      });
    });
  },
  
  observeBuiltinAdd: function(t, targetSelector, targetPlacement) {
    t.observe('click', function(ev) {
      ev.stop(); // recursion problems
      t.stopObserving('click');
      targetSelector.popdown();
      t.remove();
      targetPlacement.appendChild(t);
      
      AcceptedPaymentAndInsuranceEdit.observeBuiltinRemove(t, targetSelector, targetPlacement);
    });
  },
  
  observeBuiltinRemove: function(t, targetSelector, targetPlacement) {
    t.select('.remove a').each(function (a) { a.observe('click', function(ev) {
      ev.stop(); // recursion problems
      a.stopObserving('click');
      t.remove();
      targetSelector.el.select('.body')[0].insertBefore(t, targetSelector.el.select('.body .type.custom')[0]);
      
      AcceptedPaymentAndInsuranceEdit.observeBuiltinAdd(t, targetSelector, targetPlacement);
    }); });
  },
  
  setValue: function(t, inputToClone) {
    t.select('input').each(function(i) {i.remove();}); // rid of any past elements put there
    var val = inputToClone.cloneNode(false);
    val.addClassName('hidden');
    val.value = t.select('.name')[0].innerHTML;
    t.appendChild(val);
  },
  
  registerPopup: function(pel) {
    var popupObj = { el: pel };
    Object.extend(popupObj, TS.Popdiv);
    popupObj.createPopdiv(pel);
    return popupObj;
  }
}
AcceptedPaymentAndInsuranceEdit.init();