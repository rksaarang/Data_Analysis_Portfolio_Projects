import cv2
import pytesseract
import pandas as pd
import os

pytesseract.pytesseract.tesseract_cmd = r'C:\Users\saran\AppData\Local\Tesseract-OCR\tesseract.exe'
#C:\Users\saran\AppData\Local\Tesseract-OCR
#C:\Users\USER\AppData\Local\Tesseract-OCR\tesseract.exe

IMAGE_FILE_LOCATION = "back.jpeg"

input_img = cv2.imread(IMAGE_FILE_LOCATION) 

coordinates = [] 
  

def shape_selection(event, x, y, flags, param): 
    
    global coordinates 
  
    
    if event == cv2.EVENT_LBUTTONDOWN: 
        coordinates = [(x, y)] 
  
    
    elif event == cv2.EVENT_LBUTTONUP: 
        coordinates.append((x, y)) 
  
        
        cv2.rectangle(image, coordinates[0], coordinates[1], (0,0,255), 2) 
        cv2.imshow("image", image) 
  
 

image = input_img
image_copy = image.copy()
cv2.namedWindow("image") 
cv2.setMouseCallback("image", shape_selection) 
  
  

while True: 
    
    cv2.imshow("image", image) 
    key = cv2.waitKey(1) & 0xFF
  
    if key==13: 
        break
    
    if key == ord("c"): 
        image = image_copy.copy() 
  
if len(coordinates) == 2: 
    image_roi = image_copy[coordinates[0][1]:coordinates[1][1], coordinates[0][0]:coordinates[1][0]] 
    cv2.imshow("Selected Region of Interest - Press any key to proceed", image_roi) 
    cv2.waitKey(0) 
  

cv2.destroyAllWindows()


gray = cv2.cvtColor(image_roi, cv2.COLOR_BGR2GRAY)

  

text = pytesseract.image_to_string(gray, config='--psm 6')

cleaned_text = text.replace("‘","")
cleaned_text = cleaned_text.strip()
cleaned_text = cleaned_text.replace("®", "")
cleaned_text = cleaned_text.replace("’", "")
'''print(f"{cleaned_text} is the medicine we have found ")''' #printing the name of medicine 


#saving the output to a file
output_file = "output.txt"
with open(output_file, "w") as f:
    
    f.write(cleaned_text)
'''print(f"The output has been saved to {output_file}!")'''




#df = pd.read_excel('medicinedataset2.xlsx')
df = pd.read_excel('Drugs.xlsx')


name_to_check =cleaned_text

   
#setting mark=0
mark=0
#IF MISS
if_miss=f"If you miss a dose of {name_to_check}, take it as soon as possible. However, if it is almost time for your next dose, skip the missed dose and go back to your regular schedule. Do not double the dose."
#PREGNANCY INTERACTION
Pregnancy_interaction1="SAFE IF PRESCRIBED"
Pregnancy_interaction2="CONSULT YOUR DOCTOR"
#KIDNEY INTERACTION
kidney_interaction1="CAUTION"
kidney_interaction2="CONSULT YOUR DOCTOR"
kidney_interaction3="SAFE IF PRESCRIBED"


filtered_df = df.loc[df['name'] == name_to_check]
if name_to_check in df['name'].tolist():#analysing if the medicine exists in that dataset or not
    print(f"Consumption of {name_to_check} is permitted \n")
    print(f"What you should know before taking {cleaned_text}\n")
    if if_miss in filtered_df['if_miss'].tolist():#if you miss this medicine
        print(f"1.If you forget to take an {name_to_check}, take as quickly as possible.")
        
        mark=mark+1.5
    if Pregnancy_interaction2 in filtered_df['pregnancyInteraction'].tolist():#pregnancy interaction
            print(f'2.Consult your doctor before using {name_to_check} if you are pregnant')
            
            mark=mark+0.5 

    elif Pregnancy_interaction1 in filtered_df['pregnancyInteraction'].tolist():
            mark=mark+2
            print('2.caution')
            
    if kidney_interaction1 in filtered_df['kidneyInteraction'].tolist():#kidney interaction
        mark=mark+0
        print("3.Will negatively impact the kidneys")
    elif kidney_interaction2 in filtered_df['kidneyInteraction'].tolist():
        mark=mark+0.5
        print("3.Consult your doctor before using")
    elif kidney_interaction3 in filtered_df['kidneyInteraction'].tolist():
        mark=mark+2
        print("3.safe if prescribed ")
        
        

else:
    print(f"{name_to_check} is not present in the dataset")

print(f"\nSafety level \n{mark}/5")

if mark== 0:
 print("red")
elif mark==0.5:
    print("yellow")
elif mark==1:
    print("purple")
elif mark==2:
    print("blue")

