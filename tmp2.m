classlist =1:11;
szmax=50;
for class = classlist
    fprintf('class %d\n', class);
   
    Evaluate_overlap_better_per_class(class,szmax);
end