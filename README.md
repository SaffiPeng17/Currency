# Currency

An App to fetch currency exchange rate based on TWD. Only JPY, EUR, and USD for now.

The main page will show two days of average exchange rates recently. And if tap any exchange rate will show the chart view for showing the exchange rate histories of 7 days in past.

<img src="https://raw.githubusercontent.com/SaffiPeng17/Currency/develop/readmeImages/main_view.png" width="300">&nbsp;&nbsp;<img src="https://raw.githubusercontent.com/SaffiPeng17/Currency/develop/readmeImages/charts_view.png" width="300">

First time open App will fetch a month of exchange rates from freeCurrencyAPI and store into database. The next time open the App, will fetch new exchange rates from last fetch date to today automatically, and update database.

## Data source
[Free CurrencyAPI](https://freecurrencyapi.net/)
(not the Spot exchange rate)

## Libraries: CocoaPods
| Name | Purpose |
|------|---------|
| Alamofire | fetch API |
| RealmSwift | database, for saving histories of exchange rates |
| SnapKit | for view layout |
| Charts | draw charts |
