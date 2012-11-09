﻿function ConvertFrom-Dictionary {
	<#
		.Synopsis
			Конвертация таблицы транслитерации и любых других словарей в массив объектов
            с целью дальнейшей сериализации.
		.Example
			@{
				'А'='A';
				'Б'='B';
				'В'='V';
				'Г'='G';
			} `
			| ConvertFrom-Dictionary `
			;
	#>
	
	
	param (
		# Исходный словарь для конвейеризации
		[Parameter(
			Mandatory=$true
			, Position=0
			, ValueFromPipeline=$true
		)]
		[AllowEmptyCollection()]
		[System.Collections.IDictionary]
		$InputObject
	)

	process {
		$InputObject.GetEnumerator();
	}
}

function Add-Pair {
	<#
		.Synopsis
			Преобразование / добавление однотипных объектов со свойствами key и value в hashtable / любой другой словарь.
		.Example
			@{
				'А'='A';
				'Б'='B';
				'В'='V';
				'Г'='G';
			} `
			| ConvertFrom-Dictionary `
			| ? { 'А','Б' -contains $_.key } `
			| Add-Pair -PassThru `
			;
		.Example
			@{
				'А'='A';
				'Б'='B';
				'В'='V';
				'Г'='G';
			} `
			| ConvertFrom-Dictionary `
			| Add-Pair -InputObject (@{a=2;zzzzzzzzzzzz=3}) -PassThru
		.Example
			@{
				'А'='A';
				'Б'='B';
				'В'='V';
				'Г'='G';
			} `
			| Add-Pair -key zzzzzzzzzzzz -value 3 -PassThru
	#>

	param (
		# Ключ key для hashtable.
		[Parameter(
			Mandatory=$true
			, Position=0
			, ValueFromPipelineByPropertyName=$true
		)]
		[ValidateNotNullOrEmpty()]
		[string]
		$Key
	,
		# Значение Value для hashtable.
		[Parameter(
			Mandatory=$true
			, Position=1
			, ValueFromPipelineByPropertyName=$true
		)]
		$Value
	,
		# Исходный словарь, в который будут добавлены сопоставления.
		[Parameter(
			Mandatory=$false
			, ValueFromPipeline=$true
		)]
		[AllowEmptyCollection()]
		[System.Collections.IDictionary]
		$InputObject = @{}
	,
		[switch]
		$PassThru
	)

	begin {
		if ( $InputObject ) {
			$res = $InputObject;
		} else {
			$res = @{};
		};
	}
	process {
		if ( $_ -is [System.Collections.IDictionary] ) {
			$_.Add( $Key, $Value );
		} else {
			$res.Add( $Key, $Value );
		};
		if ( $PassThru -and ( $_ -is [System.Collections.IDictionary] ) ) {
			return $_;
		};
	}
	end {
		if ( $PassThru ) { return $res; };
	}
}

function Add-CustomMember {
	<#
		.Synopsis
			Преобразование однотипных объектов со свойствами key и value в единый объект,
			свойства которого определены поданными на конвейер парами.
		.Example
			@{
				'А'='A';
				'Б'='B';
				'В'='V';
				'Г'='G';
			} `
			| Add-CustomMember `
			;
	#>
	
	[CmdletBinding(
	)]

	param (
		# Идентификатор свойства
		[Parameter(
			Mandatory=$true
			, Position=0
			, ValueFromPipelineByPropertyName=$true
		)]
		[ValidateNotNullOrEmpty()]
		[string]
		[Alias("Key")]
		$Name
	,
		# Значение Value для hashtable
		[Parameter(
			Mandatory=$true
			, Position=1
			, ValueFromPipelineByPropertyName=$true
		)]
		$Value
#	,
#		# Тип добавляемого члена объекта
#		[Parameter(
#			Mandatory=$false
#			, ValueFromPipelineByPropertyName=$true
#		)]
#		[System.Management.Automation.PSMemberTypes]
#		$MemberType = [System.Management.Automation.PSMemberTypes]::NoteProperty
#	,
#		# Исходный словарь, в который будут добавлены сопоставления.
#		[Parameter(
#			Mandatory=$false
#		)]
#		[PSObject]
#		$InputObject = ( New-Object -TypeName PSObject )
#	,
#		[switch]
#		$PassThru
	,
		[switch]
		$Force
	)

	begin {
#		if ( $InputObject ) {
#			$res = $InputObject;
#		} else {
			$res = New-Object -TypeName PSObject;
#		};
	}
	process {
#		if ( $res ) {
			Add-Member `
				-InputObject $res `
				-MemberType NoteProperty `
				@PSBoundParameters `
			;
#		} else {
#			Add-Member -MemberType NoteProperty @PSBoundParameters;
#		};
	}
	end {
#		if ( $PassThru ) {
			return $res;
#		};
	}
}

Export-ModuleMember `
	ConvertFrom-Dictionary `
	, Add-Pair `
	, Add-CustomMember `
;
