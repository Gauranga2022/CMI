#Spazer tool for processing web pages
#

from bs4 import BeautifulSoup
import pathlib

#Variables to track the input, output and gained space
space_gained = 0
space_input = 0
space_output = 0

print("Welcome to Spazer\n")

for x in range(10):
    filename = str(x) + ".html"
    file = pathlib.Path('input/' + filename)
    if (file.exists()):

        #Read each file
        print("Reading " + filename)
        f = open('input/' + filename, 'r', errors="ignore")
        contents = f.read()   
        
        #Remove html tags
        soup = BeautifulSoup(contents, 'lxml')        
        output = soup.get_text() 
       
        #Your code begins  ###############################
        
        import re
        import pandas as pd
        
        
        lines = output.split("\n")
        for i, line in enumerate(lines):
            if line != "":
                lines[i] = line.strip()
        output = ""
        for line in lines:
            if line != "":
                output += line+"\n"
        
        buffer_l = 90
        buffer_r = 10
        
        
        states_and_ut_list_caps = ['Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh',
                                   'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand',
                                   'Karnataka', 'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur',
                                   'Meghalaya', 'Mizoram', 'Nagaland', 'Odisha', 'Punjab', 'Rajasthan',
                                   'Sikkim', 'Tamil Nadu', 'Telangana', 'Tripura', 'Uttar Pradesh',
                                   'Uttarakhand', 'West Bengal', 'Andaman and Nicobar Islands',
                                   'Chandigarh', 'Dadra and Nagar Haveli and Daman and Diu','DNHDD',
                                   'Daman and Diu','Dadra and Nagar Haveli', 'Lakshadweep', 'Delhi',
                                   'Puducherry', 'Ladakh', 'Jammu and Kashmir']
        
        

        states_and_ut_list = []

        for place in states_and_ut_list_caps:
            states_and_ut_list.append(place.lower())
        
        df = pd.read_csv("Pincode_30052019.csv", encoding='windows-1252')
        
        pincode_list = set()
        
        for _, row in df.iterrows():
            pincode = row["Pincode"]
            pincode_list.add(pincode)
        pincode_list = sorted(list(pincode_list))

        district_list = set()
        
        for _, row in df.iterrows():
            district = row["District"]
            if type(district) == str:
                district_list.add(district.lower())

        district_list = sorted(list(district_list))
        
        
        def merge(A, B):
            m, n = len(A), len(B)
            i, j = 0, 0
            answer = []
            while i < m and j < n:
                if A[i] <= B[j]:
                    answer.append(A[i])
                    i += 1
                else:
                    answer.append(B[j])
                    j += 1
            if i == m:
                answer += B[j:]
            if j == n:
                answer += A[i:]
            return answer
        
        place_list = merge(district_list, states_and_ut_list)
        
        intervals = []
        
        for place in place_list:
            i = 0
            while i < len(output):
                match = re.search(f"" + place, output[i:], re.IGNORECASE)
                if match:
                    a, b = match.span()
                    a += i
                    b += i
                    i = b
                    a, b = a-buffer_l, b+buffer_r
                    if a < 0:
                        a = 0
                    intervals.append((a, b))
                else:
                    break
        
        
        for pincode in pincode_list:
            i = 0
            while i < len(output):
                pincode = str(pincode)
                l,r = pincode[:3], pincode[3:]
                match = re.search(f"" + l + "\s?" + r, output[i:])
                if match:
                    a, b = match.span()
                    a += i
                    b += i
                    i = b
                    a, b = a-buffer_l, b+buffer_r
                    if a < 0:
                        a = 0
                    intervals.append((a, b))
                else:
                    break
        
        
        def merge_intervals(intervals):
            if not intervals:
                return []

            sorted_intervals = sorted(intervals, key=lambda x: x[0])

            merged_intervals = [sorted_intervals[0]]

            for interval in sorted_intervals[1:]:
                current_start, current_end = merged_intervals[-1]
                interval_start, interval_end = interval

                if current_end >= interval_start:
                    merged_intervals[-1] = (current_start, max(current_end, interval_end))
                else:
                    merged_intervals.append(interval)

            return merged_intervals
        
        intervals = merge_intervals(intervals)
        
        result = output
        output = ""
        for (x, y) in intervals:
            output += result[x:y] + "\n"
        
        lines = output.split("\n")
        for i, line in enumerate(lines):
            if line != "":
                lines[i] = line.strip()

        output = ""
        for line in lines:
            if line != "":
                output += line+"\n"

        
        #Your code ends  #################################              
        
        #Write the output variable contents to output/ folder.
        print ("Writing reduced " + filename)
        fw = open('output/' + filename, "w")
        fw.write(output)
        fw.close()
        f.close()
        
        #Calculate space savings
        space_input = space_input + len(contents)
        space_output = space_output + len(output)
        
space_gained = round((space_input - space_output) * 100 / space_input, 2)

print("\nTotal Space used by input files = " + str(space_input) + " characters.") 
print("Total Space used by output files = " + str(space_output) + " characters.")
print("Total Space Gained = " + str(space_gained) + "%") 
       
    




