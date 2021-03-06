//
//  PhotosViewController.m
//  Tumblr
//
//  Created by Ileen Fan on 6/24/21.
//

#import "PhotosViewController.h"
#import "PhotoCell.h"
#import "UIImageView+AFNetworking.h"

@interface PhotosViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *PhotosTableView;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.PhotosTableView.dataSource = self;
    self.PhotosTableView.delegate = self;
    self.PhotosTableView.rowHeight = 240;
    
    
    [self fetchPosts];
    
}

- (void)fetchPosts {
    NSURL *url = [NSURL URLWithString:@"https://api.tumblr.com/v2/blog/amazinglybeautifulphotography.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

                // TODO: Get the posts and store in posts property
                self.posts = dataDictionary[@"response"][@"posts"];
                NSLog(@"%@", self.posts);
                // TODO: Reload the table view
                
                [self.PhotosTableView reloadData];
            }
        }];
    [task resume];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    PhotoCell *cell = [self.PhotosTableView dequeueReusableCellWithIdentifier:@"PhotoCell"];
    NSDictionary *photos = self.posts[indexPath.row][@"photos"][0];
    
    NSDictionary *originalSize = photos[@"original_size"];
    
    NSString *urlString = originalSize[@"url"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    [cell.CellImage setImageWithURL:url];
    
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}



@end
