--流星輝巧群

--Scripted by mallu11
function c100415032.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100415032,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100415032.target)
	e1:SetOperation(c100415032.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100415032,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100415032)
	e2:SetTarget(c100415032.thtg)
	e2:SetOperation(c100415032.thop)
	c:RegisterEffect(e2)
	if Duel.GetRitualMaterialEx==nil then
		function Duel.GetRitualMaterialEx(tp,e)
			local g=Duel.GetRitualMaterial(tp)
			local g2=Duel.GetMatchingGroup(function (c,e) return c:IsCanBeRitualMaterial(nil) and c:IsReleasableByEffect(e) and not c:IsImmuneToEffect(e) end,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
			g:Merge(g2)
			return g
		end
	end
end
function c100415032.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x250) and c:IsAttackAbove(1000)
end
function c100415032.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100415032.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100415032.cfilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsAbleToHand() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c100415032.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c100415032.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsAttackAbove(1000) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,Duel.GetTurnPlayer()==tp and 2 or 1)
		tc:RegisterEffect(e1)
		if not tc:IsHasEffect(EFFECT_REVERSE_UPDATE) and c:IsRelateToEffect(e) then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		end
	end
end
function c100415032.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterialEx(tp,e):Filter(Card.IsRace,nil,RACE_MACHINE)
		return Duel.IsExistingMatchingCard(c100415032.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,nil,e,tp,mg,nil,Card.GetAttack,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c100415032.operation(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterialEx(tp,e):Filter(Card.IsRace,nil,RACE_MACHINE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100415032.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,nil,e,tp,mg,nil,Card.GetAttack,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if sg then
			mg:Merge(sg)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=c100415032.RitualCheckAdditional(tc,tc:GetAttack(),"Greater")
		local mat=mg:SelectSubGroup(tp,c100415032.RitualCheck,false,1,#mg,tp,tc,tc:GetAttack(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c100415032.RitualCheckGreater(g,c,atk)
	if atk==0 then return #g==1 end
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetAttack,atk)
end
function c100415032.RitualCheckEqual(g,c,atk)
	if atk==0 then return #g==1 and g:GetFirst():GetAttack()==0 end
	return g:CheckWithSumEqual(Card.GetAttack,atk,#g,#g)
end
function c100415032.RitualCheck(g,tp,c,atk,greater_or_equal)
	return c100415032["RitualCheck"..greater_or_equal](g,c,atk) and Duel.GetMZoneCount(tp,g,tp)>0 and (not c.mat_group_check or c.mat_group_check(g,tp))
		and (not Auxiliary.RCheckAdditional or Auxiliary.RCheckAdditional(tp,g,c))
end
function c100415032.RitualCheckAdditional(c,atk,greater_or_equal)
	if greater_or_equal=="Equal" then
		return  function(g)
					return (not Auxiliary.RGCheckAdditional or Auxiliary.RGCheckAdditional(g)) and g:GetSum(Card.GetAttack)<=atk
				end
	else
		return  function(g,ec)
					if atk==0 then return #g<=1 end
					if ec then
						return (not Auxiliary.RGCheckAdditional or Auxiliary.RGCheckAdditional(g,ec)) and g:GetSum(Card.GetAttack)-Card.GetAttack(ec)<=atk
					else
						return not Auxiliary.RGCheckAdditional or Auxiliary.RGCheckAdditional(g)
					end
				end
	end
end
function c100415032.RitualUltimateFilter(c,filter,e,tp,m1,m2,attack_function,greater_or_equal,chk)
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local atk=attack_function(c)
	Auxiliary.GCheckAdditional=c100415032.RitualCheckAdditional(c,atk,greater_or_equal)
	local res=mg:CheckSubGroup(c100415032.RitualCheck,1,#mg,tp,c,atk,greater_or_equal)
	Auxiliary.GCheckAdditional=nil
	return res
end
