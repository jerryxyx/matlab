function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
n = size(X, 2); 
if n!=input_layer_size
  print('error')
endif
y_one_hot = zeros(m,num_labels);
for i=1:m
  y_one_hot(i,y(i))=1;
end

% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

%Part1
a1 = [ones(m,1) X];
z2 = a1*Theta1';%m*(hidden_layer_size)
a2 = [ones(m,1) sigmoid(z2)];%m*(hidden_layer_size+1)
z3 = a2*Theta2';%m*(num_labels)
a3 = sigmoid(z3);%m*(num_labels)
cross_entropy = y_one_hot.*log(a3)+(1-y_one_hot).*log(1-a3);%m*num_labels 
J = -1/m * sum(cross_entropy(:));

%Part2
error3 = 1/m * (a3-y_one_hot);%m*num_labels
Theta2_without_bias = Theta2(:,2:end);%num_labels*hidden_layer_size
error2 = sigmoidGradient(z2).*(error3*Theta2_without_bias);%m*hidden_layer_size
Theta1_grad = error2'*a1;%hidden_layer_size*(input_layer_size+1)
Theta2_grad = error3'*a2;%num_labels*(hidden_layer_size+1)

%Part3
Regularized_theta1 = Theta1;
Regularized_theta2 = Theta2;
Regularized_theta1(:,1) = 0;
Regularized_theta2(:,1) = 0;
Regulariation1 = lambda/(2*m) * sum((Regularized_theta1.^2)(:));
Regulariation2 = lambda/(2*m) * sum((Regularized_theta2.^2)(:));
Regulariation1_grad = lambda/m * Regularized_theta1;
Regulariation2_grad = lambda/m * Regularized_theta2;
J += Regulariation1+Regulariation2;
Theta1_grad += Regulariation1_grad;
Theta2_grad += Regulariation2_grad;





% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
