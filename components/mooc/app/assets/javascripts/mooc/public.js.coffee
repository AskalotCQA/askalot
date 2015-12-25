//<p id="askalot-wrapper">
//
//    </p>
$('nav .course-tabs li:contains(Discussion)').hide();
$(document).ready(function() {
    var a_username = $('.user-link > div').text().trim();
    var a_userid = $('#askalot-user-id').text();
    var a_src = "http://localhost:3000/questions?utf8=%E2%9C%93&amp;tab=recent&amp;poll=true&amp;tags=dbs%2C2014-2015&amp;user_id=";
    var redirect_url = getURLParameter('redirect');
    var askalot_redirect = redirect_url ? '&amp;redirect=' + redirect_url : null;
    a_src += a_userid + "&amp;username=" + a_username + askalot_redirect;

    $('<iframe>Your browser does not support iframes!</iframe>')
        .attr('title', 'Askalot Demo')
        .attr('src', a_src)
        .attr('width', '100%')
        .attr('height', '600')
        .attr('marginwidth', '0')
        .attr('marginheight', '0')
        .attr('frameborder', '0')
        .appendTo('#askalot-wrapper')
        .load(function() {
            $(this).contents().find('body').click(function() {
                alert('Loaded!');
            });
        });

    function getURLParameter(name) {
        return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search)||[,""])[1].replace(/\+/g, '%20'))||null
    }
});
