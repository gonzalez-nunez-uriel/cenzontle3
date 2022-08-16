~ There needs to be a way for the system to be usable while this is happening
`Cenzontle` starts `Dispatcher`
`Dispatcher` reads watchlist
`Dispatcher` processes each URL
    If necessary start a new broker
        Send Cenzontle details of the new Broker
    Send URL to the right Broker
Once all URLs in watchlist are processed, `Dispatcher` sends msg to `Cenzontle`
`Cenzontle` shuts down `Dispatcher`
Broker processes each authorpage
    Check if new posts where made
    For new posts
        Check if structure is still the same
            If it is the same
                Extract right information
                Save as temp docs
Once done, the `Broker` sends a message to `Cenzontle`
Once all `Brokers` are done, `Cenzontle` lets the user know and the new index can be used.
~ Can the index be modified on the fly?