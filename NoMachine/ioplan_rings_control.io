(globals
	version = 3
	space =0
	io_order = clockwise
)

(row_margin
	(north
		(io_row ring_number=1 margin=25.0)
	)
	(east
		(io_row ring_number=1 margin=25.0)
	)
	(west
		(io_row ring_number=1 margin=25.0)
	)
	(south
		(io_row ring_number=1 margin=25.0)
	)
)
(iopad

	(northwest
		(inst name = Corner_NW cell=PCORNER_G)
	)
	(northeast
		(inst name = Corner_NE cell=PCORNER_G)
	)
	(southeast
		(inst name = Corner_SE cell=PCORNERA_G)
	)
	(southwest
		(inst name = Corner_SW cell=PCORNERA_G)
	)

	(north
		(inst name = Driver_N01 space=53)
		(inst name = Driver_N02 space=0)
		(inst name = Driver_N03 )
		(inst name = Driver_N04 )
		(inst name = Driver_N05 )
		(inst name = Driver_N06 )
		(inst name = Driver_N07 )
		(inst name = Driver_N08 )
		(inst name = Driver_N09 )
		(inst name = Driver_N10 )
		(inst name = Driver_N11 )
		(inst name = Driver_N12 )
		(inst name = Driver_N13 )
		(inst name = Driver_N14 )
		(inst name = Driver_N15 )
	)

	(east
		(inst name = Driver_E01 space=2.5)
		(inst name = Driver_E02 space=0)
		(inst name = Driver_E03 )
		(inst name = Driver_E04 )
		(inst name = Driver_E05 )
		(inst name = Driver_E06 )
		(inst name = Driver_E07 )
		(inst name = Driver_E08 )
		(inst name = Driver_E09 )
		(inst name = Driver_E10 )
		(inst name = Driver_E11 )
		(inst name = Driver_E12 )
		(inst name = Driver_E13 )
		(inst name = Driver_E14 )
		(inst name = Driver_E15 )
	)

	(south
		(inst name = Driver_S01 space=53)
		(inst name = Driver_S02 space=0)
		(inst name = Driver_S03 )
		(inst name = Driver_S04 )
		(inst name = Driver_S05 )
		(inst name = Driver_S06 )
		(inst name = Driver_S07 )
		(inst name = Driver_S08 )
		(inst name = Driver_S09 )
		(inst name = Driver_S10 )
		(inst name = Driver_S11 )
		(inst name = Driver_S12 )
		(inst name = Driver_S13 )
		(inst name = Driver_S14 )
		(inst name = Driver_S15 )
	)
	
	(west
		(inst name = Driver_W01 space=2.5)
		(inst name = Driver_W02 space=0)
		(inst name = Driver_W03 )
		(inst name = Driver_W04 )
		(inst name = Driver_W05 )
		(inst name = Driver_W06 )
		(inst name = Driver_W07 )
		(inst name = Driver_W08 )
		(inst name = Driver_W09 )
		(inst name = Driver_W10 )
		(inst name = Driver_W11 )
		(inst name = Driver_W12 )
		(inst name = Driver_W13 )
		(inst name = Driver_W14 )
		(inst name = Driver_W15 )
	)
)
