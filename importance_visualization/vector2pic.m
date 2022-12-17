function newnii=vector2pic(xin,maskfilename)

mask=load_nii(maskfilename);

f=find(mask.img>0.5); % The threshold over which the voxels are included

newimg=zeros(size(mask.img)); % Make a 3-D image with size equal to the mask
newimg(f)=xin; % And put the values of the input to the locations where the mask exceeds the mask threshold
newnii.img=newimg; % Put that in nifti format
newnii.hdr=mask.hdr; % And copy the header
end

