function cMatrix = compute_confusion_matrix(actual_state, predicted_state)
% function cMatrix = compute_confusion_matrix(actual_state, predicted_state)

% (C) M. Zhong (JHU)

cMatrix         = zeros(2);
if actual_state == true && predicted_state == true
  cMatrix(2, 2) = 1;
elseif actual_state == true && predicted_state == false
  cMatrix(2, 1) = 1;
elseif actual_state == false && predicted_state == true
  cMatrix(1, 2) = 1;
else
  cMatrix(1, 1) = 1;
end
end