# Medicine Safety Analysis with Image Processing

This Python program analyzes drug safety using OpenCV, Pytesseract, and dataset validation. It extracts medicine names from images, cross-checking against an Indian standards dataset. Additionally, it evaluates safety levels and interactions for medications.

### Features:
- **Image Processing:** Uses OpenCV and Pytesseract to extract medicine names from images.
- **Dataset Validation:** Cross-checks medicine names against an Indian standards dataset for accuracy.
- **Safety Assessment:** Determines safety levels and potential interactions for medications based on a provided dataset.
- **Output Generation:** Saves the extracted medicine name and safety analysis to an output file.

### How to Use:
1. Ensure you have Python installed.
2. Install necessary libraries using `pip install -r requirements.txt`.
3. Update the `IMAGE_FILE_LOCATION` variable with the path to your image.
4. Run the script.

### Requirements:
- Python 3.x
- OpenCV
- Pytesseract
- Pandas

### Usage Example:
- Provide an image with medicine details.
- The program will extract the medicine name and assess its safety level against a provided dataset.

### Output:
- The script generates an output file containing the extracted medicine name and safety analysis.

