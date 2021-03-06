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

A1 = [ones(m, 1) X];
Z2 = A1 * Theta1';
A2 = [ones(m, 1) sigmoid(Z2)];
Z3 = A2 * Theta2';
A3 = sigmoid(Z3);
h = A3;

y2 = zeros(size(y), num_labels);
for i = 1:m
    y2(i, y(i)) = 1;
end

sum_th1 = sum(sum((Theta1 .^ 2))) - (sum(Theta1(:, 1) .^ 2));
sum_th2 = sum(sum((Theta2 .^ 2))) - (sum(Theta2(:, 1) .^ 2));

J = (1 / m) .* sum(sum(-y2 .* log(h) - (1 - y2) .* log(1 - h), 2)) + (lambda / (2 * m)) .* (sum_th1 + sum_th2);

D2 = 0;
D1 = 0;

for t = 1:m

    % Step 1
    a1 = [1; X(t,:)'];
    z2 = Theta1 * a1;
    a2 = [1; sigmoid(z2)];
    z3 = Theta2 * a2;
    a3 = sigmoid(z3);
    
    % Step 2
    delta3 = a3 - y2(t,:)';

    % Step 3
    delta2 = (Theta2' * delta3) .* sigmoidGradient([1; z2]);
    
    % Step 4
    delta2 = delta2(2:end);
    D2 = D2 + delta3 * a2';
    D1 = D1 + delta2 * a1';

end

% Step 5
Theta2_grad = (1 / m) .* D2;
Theta1_grad = (1 / m) .* D1;

% Regularized gradient
reg2 = zeros(size(Theta2));
reg1 = zeros(size(Theta1));
reg2(:, 1) = - (lambda / m) .* Theta2(:, 1);
reg1(:, 1) = - (lambda / m) .* Theta1(:, 1);

Theta2_grad = Theta2_grad + (lambda / m) * Theta2 + reg2;
Theta1_grad = Theta1_grad + (lambda / m) * Theta1 + reg1;

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
