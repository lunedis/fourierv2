Meteor.startup(function() {
	function SelectText(text) {
	    doc = document;
	    if(doc.body.createTextRange) {
	        range = document.body.createTextRange();
	        range.moveToElementText(text);
	        range.select();
	    } else if (window.getSelection) {
	        selection = window.getSelection();      
	        range = document.createRange();
	        range.selectNodeContents(text);
	        selection.removeAllRanges();
	        selection.addRange(range);
	    }
      }

	Template['rackSmall'].helpers({
		filled: function(modules) {
			return (modules.length > 0);
		}
	});

	Template['eft'].events({
		'click .eft': function(event) {
			SelectText(event.target);
		}
	});
});