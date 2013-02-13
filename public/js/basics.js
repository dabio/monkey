(function() {
  var root = this,
      $ = root.Zepto || root.jQuery;

  // Allow the deletion of the current object.
  $('a[data-method]').on('click', function (e) {
    el = $(this);

    if (el.data('confirm') && !confirm(el.data('confirm')))
      return false;

    $.ajax({
      type: el.data('method'),
      url: e.target.href,
      timeout: 3000,
      success: function(data) {
        window.location = data;
      },
      error: function (xhr, type) {
        alert('Aktion konnte nicht ausgeführt werden, bitte erneut versuchen.')
      }
    })

    return false;
  });

}).call(this);
