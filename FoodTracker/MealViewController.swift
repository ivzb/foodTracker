import UIKit

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: Properties    
    @IBOutlet weak var tfMealName: UITextField!;    
    @IBOutlet weak var ivPhoto: UIImageView!;
    @IBOutlet weak var ratingControl: RatingControl!;
    @IBOutlet weak var btnSave: UIBarButtonItem!;
    
    /*
     This value is either passed by `MealTableViewController` in `prepareForSegue(_:sender:)`
     or constructed as part of adding a new meal.
     */
    var meal: Meal?;
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Handle the text field’s user input through delegate callbacks.
        tfMealName.delegate = self;
        
        // set up views if editing an existing Meal
        if let meal = meal {
            navigationItem.title = meal.name;
            self.tfMealName.text = meal.name;
            self.ivPhoto.image = meal.photo;
            self.ratingControl.rating = meal.rating;
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        checkValidMealName();
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // hide the keyboard
        self.tfMealName.resignFirstResponder();
        
        return true;
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.checkValidMealName();
        navigationItem.title = textField.text;
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // disable the save button while editing
        self.btnSave.enabled = false;
    }
    
    func checkValidMealName() {
        // disable the save button if the text field is empty
        let text = self.tfMealName.text ?? "";
        self.btnSave.enabled = !text.isEmpty;
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // dismiss the picker if the user canceled
        dismissViewControllerAnimated(true, completion: nil);
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {        
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage;
        
        // set photoImageView to display the selected image
        self.ivPhoto.image = selectedImage;
        
        // dismiss the picker
        dismissViewControllerAnimated(true, completion: nil);
    }
    
    // MARK: Navigation
    @IBAction func cancel(sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController;
        
        if isPresentingInAddMealMode {
            dismissViewControllerAnimated(true, completion: nil);
        } else {
            navigationController!.popViewControllerAnimated(true);
        }
        
    }
        
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === self.btnSave {
            let name = self.tfMealName.text ?? "";
            let photo = self.ivPhoto.image;
            let rating = self.ratingControl.rating;
            
            // Set the meal to be passed to MealTableViewController after the unwind segue.
            self.meal = Meal(name: name, photo: photo, rating: rating);
        }
    }
    
    // MARK: Actions   
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        // hide the keyboard
        self.tfMealName.resignFirstResponder();
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController();
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary;

        // Make sure ViewController is notified when the user picks an image
        imagePickerController.delegate = self;
        
        presentViewController(imagePickerController, animated: true, completion: nil);
    }
}