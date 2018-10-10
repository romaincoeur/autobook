var casper = require('casper').create({
	verbose: false,
	logLevel: "debug",
	pageSettings: { webSecurityEnabled: false }
});

casper.start('https://espacemembre.movidaclub.fr/AdelyaClientSpe/movida/home.jsp');

casper.on('http.status.404', function(resource) {
	    this.log('Hey, this one is 404: ' + resource.url, 'warning');
});

casper.on('remote.message', function(message) {
	    this.echo(message);
});

casper.waitForSelector("input[type='email']", function() {
	this.fillSelectors('div.connectZone', {
		'input[type = email ]' : casper.cli.get('email'),
		'input[type = password ]' : casper.cli.get('password')
		}, true);
        console.log("Logging In...")
	this.click('a#btnConnect');
});


casper.waitFor(function(){
	return !this.exists('div#makeresa.disabled');
}, function() {
	console.log("Moving to makeresa screen...");
	this.click('div#makeresa');
	console.log('Done');
});

casper.then(function(){
	this.reload(function(){
		console.log(this.getHTML('section#section_makeresa #full_categories'));
	});
});

casper.waitForSelector("div.sprite-FITNESS", function() {
	console.log("Select fitness tab...");
	this.click('div.sprite-FITNESS');
	this.click('div.fc-week tbody tr.first td.last a')
});

casper.run();
