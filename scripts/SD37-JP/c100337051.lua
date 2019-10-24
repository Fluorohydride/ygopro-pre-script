--エルシャドール・アプカローネ

--Scripted by mallu11
function c100337051.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c100337051.FShaddollCondition())
	e1:SetOperation(c100337051.FShaddollOperation())
	c:RegisterEffect(e1)
	--cannot spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(c100337051.splimit)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100337051,0))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,100337051)
	e3:SetTarget(c100337051.distg)
	e3:SetOperation(c100337051.disop)
	c:RegisterEffect(e3)
	--indes battle
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(100337051,1))
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_HANDES)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,100337151)
	e5:SetTarget(c100337051.thtg)
	e5:SetOperation(c100337051.thop)
	c:RegisterEffect(e5)
end
function c100337051.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c100337051.disfilter(c)
	return c:IsFaceup() and not c:IsDisabled() and ((c:IsType(TYPE_MONSTER) and c:IsType(TYPE_EFFECT)) or c:IsType(TYPE_SPELL+TYPE_TRAP))
end
function c100337051.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c100337051.disfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100337051.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c100337051.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function c100337051.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
function c100337051.thfilter(c,tp)
	local b=c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
	return c:IsSetCard(0x9d) and c:IsAbleToHand() and (not b or (b and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0))
end
function c100337051.thfilter2(c)
	return c:IsSetCard(0x9d) and c:IsAbleToHand()
end
function c100337051.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100337051.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,1)
end
function c100337051.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100337051.thfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if g:GetFirst():IsLocation(LOCATION_HAND+LOCATION_EXTRA) then
			Duel.ShuffleHand(tp)
			Duel.BreakEffect()
			Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		end
	end
end
function c100337051.FShaddollFilter(c,fc)
	return c:IsFusionSetCard(0x9d) and c:IsCanBeFusionMaterial(fc) and not c:IsHasEffect(6205579)
end
function c100337051.FShaddollExFilter(c,fc)
	return c:IsFaceup() and c100337051.FShaddollFilter(c,fc)
end
function c100337051.FShaddollFilter1(c,g)
	return c:IsFusionSetCard(0x9d) and g:IsExists(c100337051.FShaddollFilter2,1,c) and not g:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute())
end
function c100337051.FShaddollFilter2(c)
	return c:IsFusionSetCard(0x9d)
end
function c100337051.FShaddollSpFilter1(c,tp,mg,exg,chkf)
	return mg:IsExists(c100337051.FShaddollSpFilter2,1,c,tp,c,chkf) or (exg and exg:IsExists(c100337051.FShaddollSpFilter2,1,c,tp,c,chkf))
end
function c100337051.FShaddollSpFilter2(c,tp,mc,chkf)
	local sg=Group.FromCards(c,mc)
	if sg:IsExists(aux.TuneMagicianCheckX,1,nil,sg,EFFECT_TUNE_MAGICIAN_F) then return false end
	if not aux.MustMaterialCheck(sg,tp,EFFECT_MUST_BE_FMATERIAL) then return false end
	return ((c100337051.FShaddollFilter1(c,sg) and c100337051.FShaddollFilter2(mc))
		or (c100337051.FShaddollFilter1(mc,sg) and c100337051.FShaddollFilter2(c)))
		and (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg)>0)
end
function c100337051.FShaddollCondition()
	return  function(e,g,gc,chkf)
			if g==nil then return aux.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
			local c=e:GetHandler()
			local mg=g:Filter(c100337051.FShaddollFilter,nil,c)
			local tp=e:GetHandlerPlayer()
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			local exg=nil
			if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
				exg=Duel.GetMatchingGroup(c100337051.FShaddollExFilter,tp,0,LOCATION_MZONE,mg,c)
			end
			if gc then
				if not mg:IsContains(gc) then return false end
				return c100337051.FShaddollSpFilter1(gc,tp,mg,exg,chkf)
			end
			return mg:IsExists(c100337051.FShaddollSpFilter1,1,nil,tp,mg,exg,chkf)
		end
end
function c100337051.FShaddollOperation()
	return  function(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
			local c=e:GetHandler()
			local mg=eg:Filter(c100337051.FShaddollFilter,nil,c)
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			local exg=nil
			if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
				exg=Duel.GetMatchingGroup(c100337051.FShaddollExFilter,tp,0,LOCATION_MZONE,mg,c)
			end
			local g=nil
			if gc then
				g=Group.FromCards(gc)
				mg:RemoveCard(gc)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				g=mg:FilterSelect(tp,c100337051.FShaddollSpFilter1,1,1,nil,tp,mg,exg,chkf)
				mg:Sub(g)
			end
			if exg and exg:IsExists(c100337051.FShaddollSpFilter2,1,nil,tp,g:GetFirst(),chkf)
				and (mg:GetCount()==0 or (exg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81788994,0)))) then
				fc:RemoveCounter(tp,0x16,3,REASON_EFFECT)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local sg=exg:FilterSelect(tp,c100337051.FShaddollSpFilter2,1,1,nil,tp,g:GetFirst(),chkf)
				g:Merge(sg)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local sg=mg:FilterSelect(tp,c100337051.FShaddollSpFilter2,1,1,nil,tp,g:GetFirst(),chkf)
				g:Merge(sg)
			end
			Duel.SetFusionMaterial(g)
		end
end
