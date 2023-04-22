--ピュアリィ・シェアリィ！？
local s,id,o=GetID()
function s.initial_effect(c)
	-- sp summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
end


function s.filter1(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x18c)
end

function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:GetControler()==tp end
	if chk == 0 then
        return Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function s.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x18c) and c:GetLevel()==1
end

function s.filter3(c,e,tp,mc,rank,attr)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x18c) and c:GetRank()==rank and c:GetAttribute()~=attr and mc:IsCanBeXyzMaterial(c)
end

function s.filter4(c,e,tp,tc)
    local g=tc:GetOverlayGroup()
    local function filter5(c2)
        return c2:GetCode()==c:GetCode()
    end
    local ng=g:Filter(filter5,nil)
	return c:IsType(TYPE_QUICKPLAY) and c:IsSetCard(0x18c) and ng:GetCount() > 0
end

function s.op1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g1=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil)
        local mc=g1:GetFirst()
        if mc then
            local res=Duel.SpecialSummonStep(mc,0,tp,tp,false,false,POS_FACEUP)
			if not res then
				Duel.SpecialSummonComplete()
				return
			end
			--effect disable
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			mc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			mc:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
			Duel.AdjustAll()
			
			--target card
			local tc=Duel.GetFirstTarget()
			if not tc:IsRelateToEffect(e) then return end
			--sp summoned monster
			if not aux.MustMaterialCheck(mc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			--xyz summon
			local g2=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mc,tc:GetRank(),tc:GetAttribute())
			local sc=g2:GetFirst()
			if sc then
				Duel.BreakEffect()
				sc:SetMaterial(Group.FromCards(mc))
				Duel.Overlay(sc,Group.FromCards(mc))
				Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
				sc:CompleteProcedure()

				--add xyz material
				if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					local g3=Duel.SelectMatchingCard(tp,s.filter4,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
					local c4 = g3:GetFirst()
					if c4 then
						Duel.Overlay(sc,c4)
					end
				end
			end
        end
    end

end
