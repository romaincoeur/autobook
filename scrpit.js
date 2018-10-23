// Usage
// $ casperjs script.js --email=<your email> --password=<password>


var casper = require('casper').create({
	verbose: false,
	logLevel: "debug",
	pageSettings: { webSecurityEnabled: false }
});

if (!casper.cli.get('email') || !casper.cli.get('password'))
	throw new Error("params email and password must be defined following this pattern \n casperjs script.js --email=<your email> --password=<password>");

casper.start('https://espacemembre.movidaclub.fr/AdelyaClientSpe/movida/home.jsp');

casper.on('http.status.404', function(resource) {
	    this.log('Hey, this one is 404: ' + resource.url, 'warning');
});

casper.on('remote.message', function(message) {
	    this.echo(message);
});

casper.waitForSelector("input[type='email']", function login() {
	this.fillSelectors('div.connectZone', {
		'input[type = email ]' : casper.cli.get('email'),
		'input[type = password ]' : casper.cli.get('password')
		}, true);
        console.log("Logging In...")
	this.click('a#btnConnect');
});


casper.waitFor(function goToCalendar(){
	return this.exists('div.sprite-FITNESS');
}, function() {
	console.log("Moving to makeresa screen...");
	this.click('div#makeresa');
	console.log('Done');
});

casper.then(function clickTimeslot(){
		console.log(this.getHTML('section#section_makeresa #full_categories'));
});

casper.waitForSelector("div.sprite-FITNESS", function() {
	console.log("Select fitness tab...");
	this.click('div.sprite-FITNESS');
	this.click('div.fc-week tbody tr.first td.last a')
});

casper.run();
