

// Get access token
curl -c cookies.txt https://espacemembre.movidaclub.fr/AdelyaClientSpe/movida/home.jsp | grep token

// Login
curl -c cookies.txt -b cookies.txt -d "login=coeurro@gmail.com&password=azerty1234&facebookId=&token=977a4ab788b9a490a160" -X POST 'https://espacemembre.movidaclub.fr/AdelyaClientSpe/movida/process/processConnect.jsp' >> cookies.txt

// Modifier le fichier cookies.txt à la main : message devient password
gedit cookies.txt

// Get new token
curl -b cookies.txt 'https://espacemembre.movidaclub.fr/AdelyaClientSpe/movida/home.jsp' | grep token

// fetch calendar events
curl -b cookies.txt 'https://espacemembre.movidaclub.fr/AdelyaClientSpe/movida/process/loadCalendarEvents.jsp?token=7474aa5f7dd85e20e39c&id=14723627&idGroup=1257&category=Fitness'

// Make reservation
curl -b cookies.txt 'https://espacemembre.movidaclub.fr/AdelyaClientSpe/movida/process/processResa.jsp?idEntry=507541&status=pending&action=makeResa'
