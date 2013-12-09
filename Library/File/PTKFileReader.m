classdef PTKFileReader < handle
    % PTKFileReader. A helper class to assist with parsing a text file
    %
    %
    %     Licence
    %     -------
    %     Part of the TD Pulmonary Toolkit. http://code.google.com/p/pulmonarytoolkit
    %     Author: Tom Doel, 2013.  www.tomdoel.com
    %     Distributed under the GNU GPL v3 licence. Please see website for details.
    %

    properties (Access = private)
        FileId
        Reporting
    end
    
    methods
        function obj = PTKFileReader(file_path, file_name, transfer_syntax, reporting)
            obj.Reporting = reporting;
            full_file_name = fullfile(file_path, file_name);

            switch transfer_syntax.Endian
                case PTKEndian.BigEndian
                    file_encoding = 'b';
                case PTKEndian.LittleEndian
                    file_encoding = 'l';
                otherwise
                    error('Unknown file encoding');
            end

            switch transfer_syntax.CharacterEncoding
                case PTKDicomCharacterEncoding.UTF8
                    character_encoding = 'UTF-8';
                otherwise
                    error('Unknown character encoding');
            end

            file_id = fopen(full_file_name, 'r', file_encoding, character_encoding);

            if (file_id == -1)
                reporting.Error('PTKFileReader:CannotOpenFile', ['Unable to open file ' full_file_name]);
            else
                obj.FileId = file_id;
            end

        end
        
        function data = ReadData(obj, data_type, number_of_bytes)
            
            if strcmp(data_type, 'char')
                number_of_words = number_of_bytes;
            else
                bytes_in_type = PTKSystemUtilities.GetBytesInType(data_type, obj.Reporting);
                number_of_words = ceil(number_of_bytes/bytes_in_type);
            end
            
            data = fread(obj.FileId, [1, number_of_words], data_type);
            if strcmp(data_type, 'char')
                data = char(data);
            end
        end
        
        function data = ReadString(obj, number_of_bytes)
            data = fread(obj.FileId, [1, number_of_bytes], '*char');
        end
        
        function Close(obj)
            if ~isempty(obj.FileId)
                fclose(obj.FileId);
                obj.FileId = [];
            end
        end
        
        function delete(obj)
            obj.Close;
        end
        
        function more_data = MoreDataToRead(obj)
            more_data = ~feof(obj.FileId);
        end
        
        function Skip(obj, number_of_bytes)
            fseek(obj.FileId, 'cof', number_of_bytes);
        end

    end
end