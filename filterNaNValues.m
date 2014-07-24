function filteredField = filterNaNValues(input)

h = ones(3,3,3);
h = h/sum(h(:));
h(2,2,2) = 0;

input_m = input;
input_m(isnan(input_m)) = 0;

inputFiltered = imfilter(input_m,h,'symmetric');

filteredField = input;
filteredField(isnan(input)) = inputFiltered(isnan(input));

end