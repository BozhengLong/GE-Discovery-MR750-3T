import matplotlib.pyplot as plt


filename = 'rp_filename.txt'
data = []
with open(filename, 'r') as file:
    for line in file:
        line = line.strip()
        if line:
            values = line.split()
            data.append([float(value) for value in values])


x = [row[0] for row in data]
y = [row[1] for row in data]
z = [row[2] for row in data]
rotation_x = [row[3] for row in data]
rotation_y = [row[4] for row in data]
rotation_z = [row[5] for row in data]


plt.figure(figsize=(10, 6))
plt.plot(x, label='X')
plt.plot(y, label='Y')
plt.plot(z, label='Z')
plt.plot(rotation_x, label='Rotation X')
plt.plot(rotation_y, label='Rotation Y')
plt.plot(rotation_z, label='Rotation Z')
plt.xlabel('Time point')
plt.ylabel('mm/deg')
plt.title('Head motion')
plt.legend()
plt.ylim(-0.6, 0.4)
plt.grid(True)
plt.show()
