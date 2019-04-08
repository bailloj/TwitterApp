//
//  HomeTableTableViewController.swift
//  Twitter
//
//  Created by Jireh Grace Baillo on 3/25/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]() //Local var for Array of Dictionaries
    var numberOfTweet: Int!
    
    let myRefreshControl = UIRefreshControl() // For pulling down to refresh tweet
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged) // Everytime I pull down I call loadTweet again
        tableView.refreshControl = myRefreshControl //Starts spinning wheel for refresh
    }
    
/*
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
    }
*/
    @objc func loadTweets(){
        numberOfTweet = 20
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json" // Twitter API resource URL
        let myParams = ["count":numberOfTweet] // Parameters for how many tweets to load
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams, success: { (tweets:[NSDictionary]) in //If successfully retrieved the tweets:
            self.tweetArray.removeAll() // Remove all past tweets from local var tweetArray
            for tweet in tweets { //for each tweet that we're retrieving
                self.tweetArray.append(tweet) //Append the tweet to the end of tweetArray
            }
            self.tableView.reloadData() //Reload the data in the table view to display the new tweets
            self.myRefreshControl.endRefreshing() // End spinning circle for refresh control
        }, failure: { (Error) in // If failed
            print("Could not retrieve tweets! Oh no!")
        })
    }
    
    
    func loadMoreTweets(){ // Function to facilitate infinite scroll
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweet = numberOfTweet + 20 // adds 20 to numberofTweet set by loadTweets function/ prev iteration of loadMoreTweets
        let myParams = ["count":numberOfTweet] // Parameters for how many tweets to load
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams, success: { (tweets:[NSDictionary]) in //If successfully retrieved the tweets:
            self.tweetArray.removeAll() // Remove all past tweets from local var tweetArray
            for tweet in tweets { //for each tweet that we're retrieving
                self.tweetArray.append(tweet) //Append the tweet to the end of tweetArray
            }
            self.tableView.reloadData() //Reload the data in the table view to display the new tweets
        }, failure: { (Error) in // If failed
            print("Could not retrieve tweets! Oh no!")
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { // function that calls loadMoretweets when we hit the end of the screen
        if indexPath.row + 1 == tweetArray.count{ // if the row we are on + 1 is equal to the size of our tweetArray
            loadMoreTweets() // call loadMoreTweets
        }
    }
    
    
    
    @IBAction func onLogout(_ sender: Any) { //Action once logout button is clicked
        TwitterAPICaller.client?.logout() // Calls function from API docs to log out
        self.dismiss(animated: true, completion: nil) // Goes back to log in screen
        UserDefaults.standard.set(false, forKey: "userLoggedIn") //Sets key for userLoggedIn to false b/c logged out
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell //Sets reusable cell as tweetCell in certain row
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary //Creates new dict for user field from larger dict of a certain tweet
        cell.userNameLabel.text = user["name"] as? String //sets name
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String //sets text
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!) // following code adds in image
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count // returns # of rows
    }


}
