--サイバー・ダーク・キメラ
--not fully implemented
--Scripted by mallu11
function c100341002.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100341002,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100341002)
	e1:SetCost(c100341002.thcost)
	e1:SetTarget(c100341002.thtg)
	e1:SetOperation(c100341002.thop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100341002,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,100341102)
	e2:SetTarget(c100341002.tgtg)
	e2:SetOperation(c100341002.tgop)
	c:RegisterEffect(e2)
	--
	if not aux.fus_mat_hack_check then
		aux.fus_mat_hack_check=true
		function aux.fus_mat_hack_exmat_filter(c)
			return c:IsHasEffect(EFFECT_EXTRA_FUSION_MATERIAL,c:GetControler())
		end
		_GetFusionMaterial=Duel.GetFusionMaterial
		function Duel.GetFusionMaterial(tp)
			local g=_GetFusionMaterial(tp)
			local exg=Duel.GetMatchingGroup(aux.fus_mat_hack_exmat_filter,tp,LOCATION_GRAVE,0,nil)
			return g+exg
		end
		_SendtoGrave=Duel.SendtoGrave
		function Duel.SendtoGrave(tg,reason)
			if reason~=REASON_EFFECT+REASON_MATERIAL+REASON_FUSION or Auxiliary.GetValueType(tg)~="Group" then
				return _SendtoGrave(tg,reason)
			end
			local rg=tg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
			tg:Sub(rg)
			local tc=rg:Filter(aux.fus_mat_hack_exmat_filter,nil):GetFirst()
			if tc then
				local te=tc:IsHasEffect(EFFECT_EXTRA_FUSION_MATERIAL,tc:GetControler())
				te:UseCountLimit(tc:GetControler())
			end
			local ct1=_SendtoGrave(tg,reason)
			local ct2=Duel.Remove(rg,POS_FACEUP,reason)
			return ct1+ct2
		end
	end
end
function c100341002.costfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function c100341002.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100341002.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c100341002.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c100341002.thfilter(c)
	return c:IsCode(37630732) and c:IsAbleToHand()
end
function c100341002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100341002.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100341002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100341002.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(c100341002.limittg)
	e1:SetValue(c100341002.fuslimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(100341002,2))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
	e2:SetTargetRange(LOCATION_GRAVE,0)
	e2:SetCountLimit(1,100341202)
	e2:SetTarget(c100341002.mttg)
	e2:SetValue(c100341002.fuslimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c100341002.limittg(e,c)
	return not (c:IsRace(RACE_DRAGON+RACE_MACHINE) and c:IsSetCard(0x93))
end
function c100341002.fuslimit(e,c,sumtype)
	if not c then return false end
	return c:IsControler(e:GetHandlerPlayer())
end
function c100341002.mttg(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c100341002.tgfilter(c,tp)
	return c:IsSetCard(0x4093) and c:IsType(TYPE_MONSTER)
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,c:GetCode()) and c:IsAbleToGrave()
end
function c100341002.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100341002.tgfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c100341002.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100341002.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
