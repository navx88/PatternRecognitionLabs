function [G_W, G_W0, G_n_ab, G_n_ba] = generate_desc_classifier( samples_a, samples_b, J_limit )
% globals for storing each discriminant data
    j = 0;
    G_W = [];
    G_W0 = [];
    G_n_ab = [];
    G_n_ba = [];

    %% Determine Descriminants

    exhaustible_a = samples_a;
    exhaustible_b = samples_b;

    while ((size(exhaustible_a,2) > 0) && (size(exhaustible_b,2) > 0)) && (j < J_limit)
        j = j + 1;

        num_a_samples = size(exhaustible_a,2);
        num_b_samples = size(exhaustible_b,2);

        confusion_n_ab = num_a_samples;
        confusion_n_ba = num_b_samples;


        while ((confusion_n_ab > 0) && (confusion_n_ba > 0))
            rand_a_index = floor(rand()*num_a_samples + 1);
            rand_b_index = floor(rand()*num_b_samples + 1);

            rand_a = exhaustible_a(:,rand_a_index);
            rand_b = exhaustible_b(:,rand_b_index);

            % determine MED classifier
            W = (rand_a - rand_b);
            W0 = 0.5 * (rand_b'*rand_b - rand_a'*rand_a);


            confusion_n_ab = sum(sign(W'*exhaustible_a + W0) == -1);
            confusion_n_ba = sum(sign(W'*exhaustible_b + W0) ==  1);

        end

        G_W = [G_W W];
        G_W0 = [G_W0 W0];
        G_n_ab = [G_n_ab confusion_n_ab];
        G_n_ba = [G_n_ba confusion_n_ba];

        new_exhaustible_a = [];
        new_exhaustible_b = [];

        if (confusion_n_ab == 0)
            for i=1:num_b_samples
                if (sign(W'*exhaustible_b(:,i) + W0) >= 0)
                    new_exhaustible_b = [new_exhaustible_b exhaustible_b(:,i)];
                end
            end
        else
            new_exhaustible_b = exhaustible_b;
        end

        if (confusion_n_ba == 0)
            for i=1:num_a_samples
                if (sign(W'*exhaustible_a(:,i) + W0) <= 0)
                    new_exhaustible_a = [new_exhaustible_a exhaustible_a(:,i)];
                end
            end
        else
            new_exhaustible_a = exhaustible_a;
        end

        exhaustible_a = new_exhaustible_a;
        exhaustible_b = new_exhaustible_b;

end

